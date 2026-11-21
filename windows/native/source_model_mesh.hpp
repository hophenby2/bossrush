// 原作背景网格：复用 Sub 的 GPU Mesh，按顺序批量更新实例矩阵、UV 和材质参数。
#pragma once
#include <win32/base.hpp>
#include <d3d11.h>
#include "core/Graphics/Direct3D11/Mesh.hpp"
#include "LuaBinding/LuaWrapper.hpp"
#include "LuaBinding/modern/GameObject.hpp"
#include "AppFrame.h"
#include <d3dcompiler.h>
#include <wrl/client.h>
#include <algorithm>
#include <array>
#include <cstring>
#include <memory>
#include <stdexcept>
#include <unordered_map>
#include <vector>

namespace luastg::source_mesh {
using Microsoft::WRL::ComPtr;
static constexpr char type_name[]="BossRush.SourceModelMesh";
static void check(HRESULT hr,char const* message) {
    if (FAILED(hr)) throw std::runtime_error(message);
}
static constexpr char shader[]=R"(
cbuffer Camera : register(b0) { float4x4 view_proj; };
struct Parameters {
    float4x4 world;
    float4 uv_transform;
    float4 tint;
    float4 options;
    float4 fog;
    float4 fog_color;
};
cbuffer Model : register(b1) { Parameters models[128]; };
Texture2D image : register(t0);
SamplerState image_sampler : register(s0);
struct Input { float3 position:POSITION0; float2 uv:TEXCOORD0; float4 color:COLOR0; uint instance:SV_InstanceID; };
struct Output { float4 position:SV_POSITION; float2 uv:TEXCOORD0; float4 color:COLOR0;
    float3 world_position:TEXCOORD1; nointerpolation uint instance:TEXCOORD2; };
Output vs_main(Input v) {
    Parameters p=models[v.instance];
    Output o;
    float4 world_position=mul(p.world,float4(v.position,1));
    o.position=mul(view_proj,world_position);o.world_position=world_position.xyz;o.instance=v.instance;
    o.uv=v.uv*p.uv_transform.xy+p.uv_transform.zw;
    o.color=v.color*p.tint;
    return o;
}
float4 ps_main(Output v):SV_TARGET {
    Parameters p=models[v.instance];
    float4 sample_color=p.options.w>=2 ? float4(1,1,1,1):image.Sample(image_sampler,v.uv);
    if (p.options.z>=1 && p.options.w==1) sample_color.rgb=sample_color.a>0 ? sample_color.rgb/sample_color.a:0;
    float4 color=sample_color*v.color;
    if (p.options.x>0) clip(color.a-p.options.x);
    if (p.options.y>0) {
        float d=distance(float3(p.fog.zw,p.fog_color.w),v.world_position);
        float k=saturate((d-p.fog.x)/(p.fog.y-p.fog.x));
        color=lerp(color,float4(p.fog_color.rgb,color.a),k);
    }
    if (p.options.z>=1) color.rgb*=color.a;
    return color;
}
)";
struct Pipeline final : core::IGraphicsDeviceEventListener {
    core::SmartReference<core::IGraphicsDevice> device;
    ComPtr<ID3D11VertexShader> vs;
    ComPtr<ID3D11PixelShader> ps;
    ComPtr<ID3D11Buffer> constants;
    ComPtr<ID3D11BlendState> blends[4];
    ComPtr<ID3D11DepthStencilState> depths[3];
    ComPtr<ID3D11RasterizerState> rasters[3];
    bool ready=false;
    explicit Pipeline(core::IGraphicsDevice* d):device(d) { device->addEventListener(this); }
    ~Pipeline() { device->removeEventListener(this); }
    void onGraphicsDeviceCreate() override {}
    void onGraphicsDeviceDestroy() override {
        ready=false;
        vs.Reset();ps.Reset();constants.Reset();
        for (auto& s:blends) s.Reset();
        for (auto& s:depths) s.Reset();
        for (auto& s:rasters) s.Reset();
    }
    void ensure() {
        if (ready) return;
        onGraphicsDeviceDestroy();
        auto* d=static_cast<ID3D11Device*>(device->getNativeDevice());
        ComPtr<ID3DBlob> vertex,pixel,error;
        auto compile=[&](char const* entry,char const* profile,ComPtr<ID3DBlob>& out) {
            const auto hr=D3DCompile(shader,sizeof(shader)-1,"BossRush.SourceModelMesh",nullptr,nullptr,
                entry,profile,D3DCOMPILE_ENABLE_STRICTNESS|D3DCOMPILE_OPTIMIZATION_LEVEL3,0,
                out.GetAddressOf(),error.ReleaseAndGetAddressOf());
            if (FAILED(hr)) throw std::runtime_error(error ?
                std::string(static_cast<char const*>(error->GetBufferPointer()),error->GetBufferSize()):"原作网格着色器编译失败");
        };
        compile("vs_main","vs_4_0",vertex);compile("ps_main","ps_4_0",pixel);
        check(d->CreateVertexShader(vertex->GetBufferPointer(),vertex->GetBufferSize(),nullptr,vs.GetAddressOf()),"创建原作网格顶点着色器失败");
        check(d->CreatePixelShader(pixel->GetBufferPointer(),pixel->GetBufferSize(),nullptr,ps.GetAddressOf()),"创建原作网格像素着色器失败");
        D3D11_BUFFER_DESC cb{};cb.ByteWidth=144*128;cb.Usage=D3D11_USAGE_DYNAMIC;
        cb.BindFlags=D3D11_BIND_CONSTANT_BUFFER;cb.CPUAccessFlags=D3D11_CPU_ACCESS_WRITE;
        check(d->CreateBuffer(&cb,nullptr,constants.GetAddressOf()),"创建原作网格参数缓冲区失败");
        for (int i=0;i<4;++i) {
            D3D11_BLEND_DESC b{};auto& rt=b.RenderTarget[0];rt.BlendEnable=TRUE;
            rt.SrcBlend=i==1 ? D3D11_BLEND_SRC_ALPHA:D3D11_BLEND_ONE;
            rt.DestBlend=(i==1 || i==3) ? D3D11_BLEND_ONE:D3D11_BLEND_INV_SRC_ALPHA;
            rt.SrcBlendAlpha=i==1 ? D3D11_BLEND_SRC_ALPHA:D3D11_BLEND_ONE;
            rt.DestBlendAlpha=i==1 ? D3D11_BLEND_ONE:D3D11_BLEND_INV_SRC_ALPHA;
            rt.BlendOp=rt.BlendOpAlpha=D3D11_BLEND_OP_ADD;rt.RenderTargetWriteMask=D3D11_COLOR_WRITE_ENABLE_ALL;
            check(d->CreateBlendState(&b,blends[i].GetAddressOf()),"创建原作网格混合状态失败");
        }
        for (int i=0;i<3;++i) {
            D3D11_DEPTH_STENCIL_DESC depth{};depth.DepthEnable=i!=0;
            depth.DepthWriteMask=i==2 ? D3D11_DEPTH_WRITE_MASK_ALL:D3D11_DEPTH_WRITE_MASK_ZERO;
            depth.DepthFunc=D3D11_COMPARISON_LESS_EQUAL;
            check(d->CreateDepthStencilState(&depth,depths[i].GetAddressOf()),"创建原作网格深度状态失败");
            D3D11_RASTERIZER_DESC raster{};raster.FillMode=D3D11_FILL_SOLID;
            raster.CullMode=i==0 ? D3D11_CULL_NONE:D3D11_CULL_BACK;
            raster.FrontCounterClockwise=i==2;raster.DepthClipEnable=TRUE;raster.ScissorEnable=TRUE;
            check(d->CreateRasterizerState(&raster,rasters[i].GetAddressOf()),"创建原作网格剔除状态失败");
        }
        ready=true;
    }
};
struct Mesh {
    core::SmartReference<core::Graphics::IMesh> data;
    core::SmartReference<core::ITexture2D> texture;
    std::shared_ptr<Pipeline> pipeline;
};
// Sub 的状态缓存不感知原生 D3D 调用，离开本次绘制前完整还原所改状态。
struct SavedState {
    ID3D11DeviceContext* c;
    ComPtr<ID3D11VertexShader> vs;ComPtr<ID3D11PixelShader> ps;
    ComPtr<ID3D11InputLayout> layout;
    ComPtr<ID3D11Buffer> vb,ib,vconstants,pconstants;
    ComPtr<ID3D11ShaderResourceView> texture;ComPtr<ID3D11SamplerState> sampler;
    ComPtr<ID3D11BlendState> blend;ComPtr<ID3D11DepthStencilState> depth;ComPtr<ID3D11RasterizerState> raster;
    UINT stride{},offset{},iboffset{},mask{},stencil{};FLOAT factors[4]{};
    DXGI_FORMAT format{};D3D11_PRIMITIVE_TOPOLOGY topology{};
    explicit SavedState(ID3D11DeviceContext* ctx):c(ctx) {
        c->VSGetShader(vs.GetAddressOf(),nullptr,nullptr);c->PSGetShader(ps.GetAddressOf(),nullptr,nullptr);
        c->IAGetInputLayout(layout.GetAddressOf());c->IAGetPrimitiveTopology(&topology);
        c->IAGetVertexBuffers(0,1,vb.GetAddressOf(),&stride,&offset);c->IAGetIndexBuffer(ib.GetAddressOf(),&format,&iboffset);
        c->VSGetConstantBuffers(1,1,vconstants.GetAddressOf());c->PSGetConstantBuffers(1,1,pconstants.GetAddressOf());
        c->PSGetShaderResources(0,1,texture.GetAddressOf());c->PSGetSamplers(0,1,sampler.GetAddressOf());
        c->OMGetBlendState(blend.GetAddressOf(),factors,&mask);c->OMGetDepthStencilState(depth.GetAddressOf(),&stencil);
        c->RSGetState(raster.GetAddressOf());
    }
    ~SavedState() {
        c->VSSetShader(vs.Get(),nullptr,0);c->PSSetShader(ps.Get(),nullptr,0);
        c->IASetInputLayout(layout.Get());c->IASetPrimitiveTopology(topology);
        auto* v=vb.Get();c->IASetVertexBuffers(0,1,&v,&stride,&offset);c->IASetIndexBuffer(ib.Get(),format,iboffset);
        auto* vc=vconstants.Get();auto* pc=pconstants.Get();c->VSSetConstantBuffers(1,1,&vc);c->PSSetConstantBuffers(1,1,&pc);
        auto* tex=texture.Get();auto* samp=sampler.Get();c->PSSetShaderResources(0,1,&tex);c->PSSetSamplers(0,1,&samp);
        c->OMSetBlendState(blend.Get(),factors,mask);c->OMSetDepthStencilState(depth.Get(),stencil);c->RSSetState(raster.Get());
    }
};
struct VertexKey {
    std::array<uint32_t,5> bits;
    bool operator==(VertexKey const& b) const noexcept { return bits==b.bits; }
};
struct VertexHash {
    size_t operator()(VertexKey const& v) const noexcept {
        size_t h=2166136261u;for (auto n:v.bits) h=(h^n)*16777619u;return h;
    }
};
static float number(lua_State* L,int table,size_t i) {
    lua_rawgeti(L,table,static_cast<int>(i));
    if (!lua_isnumber(L,-1)) { lua_pop(L,1);throw std::runtime_error("原作网格参数不是数字"); }
    const auto n=static_cast<float>(lua_tonumber(L,-1));lua_pop(L,1);return n;
}
// 原作状态的等价浅拷贝：不复用仍被绑定对象持有的表，也不改变字段值或生命周期。
static int copyTable(lua_State* L) {
    luaL_checktype(L,1,LUA_TTABLE);
    const auto capacity=luaL_optinteger(L,2,128);
    luaL_argcheck(L,capacity>=0 && capacity<=0x7fffffff,2,"状态表预分配容量无效");
    // 第三参只能传入调用方准备的全新容器；不回收、清空或复用已发射弹体的状态。
    if (lua_isnoneornil(L,3)) lua_createtable(L,0,static_cast<int>(capacity));
    else { luaL_checktype(L,3,LUA_TTABLE);lua_pushvalue(L,3); }
    const int output=lua_gettop(L);
    lua_Integer count=0;lua_pushnil(L);
    while (lua_next(L,1)) {
        lua_pushvalue(L,-2);lua_pushvalue(L,-2);lua_rawset(L,output);
        lua_pop(L,1);++count;
    }
    lua_pushinteger(L,count);return 2;
}
// 等价于普通弹 projected 中的几何属性赋值；事件、计时、分组与回收仍由原 Lua 路径处理。
static int syncBulletGeometry(lua_State* L) {
    auto* object=binding::GameObject::as(L,1);
    std::array<double,7> values;
    for (int i=0;i<7;++i) values[i]=luaL_checknumber(L,i+2);
    object->x=values[0];object->y=values[1];object->vx=object->vy=0;
#ifdef GLOBAL_SCALE_COLLI_SHAPE
    object->a=values[2]*LRES.GetGlobalImageScaleFactor();object->b=values[3]*LRES.GetGlobalImageScaleFactor();
#else
    object->a=values[2];object->b=values[3];
#endif
    object->rect=false;object->UpdateCollisionCircleRadius();
    object->rot=values[4]*L_DEG_TO_RAD;object->hscale=values[5];object->vscale=values[6];
    return 0;
}
// 只读上一完整帧的引擎计时，包含 Lua 之外的提交与等待，不改变帧调度。
extern "C" double GetSourcePacerWait();
extern "C" unsigned long long GetSourcePresentBusy();
static int frameStatistics(lua_State* L) {
    auto const& s=LAPP.getFrameStatistics();
    for (double v:{s.wait_time,s.update_time,s.render_time,s.present_time,s.total_time}) lua_pushnumber(L,v*1000);
    lua_pushnumber(L,GetSourcePacerWait()*1000);
    // FrameQuery 已在复用查询槽时取回数据，此处只读缓存，不额外等待 GPU。
    lua_pushnumber(L,LAPP.getFrameRenderStatistics().render_time*1000);
    lua_pushnumber(L,static_cast<lua_Number>(GetSourcePresentBusy()));
    return 8;
}
// 与官方 Color(a,r,g,b) 的整数转换、截断和钳位一致，直接写图片颜色，免去逐弹临时 userdata。
static core::Color4B imageColorRGBA(lua_State* L,int first) {
    auto channel=[L](int i) { return static_cast<uint8_t>(std::clamp<lua_Integer>(luaL_checkinteger(L,i),0,255)); };
    return core::Color4B(channel(first+1),channel(first+2),channel(first+3),channel(first));
}
static int imageStateRGBA(lua_State* L) {
    const auto color=imageColorRGBA(L,3);
    core::SmartReference<IResourceSprite> sprite=LRES.FindSprite(luaL_checkstring(L,1));
    if (!sprite) return luaL_error(L,"image '%s' not found.",luaL_checkstring(L,1));
    sprite->SetBlendMode(TranslateBlendMode(L,2));sprite->SetColor(color);
    return 0;
}
// 按普通 Render 的数值转换绘制同一对象，省去逐弹六次属性跨界读取；顺序仍由 ObjRender 决定。
static int renderObjectImage(lua_State* L) {
    if (!LAPP.getRenderer2D()->isBatchScope()) return luaL_error(L,"invalid render operation");
    auto* object=binding::GameObject::as(L,2);
    core::SmartReference<IResourceSprite> sprite=LRES.FindSprite(luaL_checkstring(L,1));
    if (!sprite) return luaL_error(L,"can't find sprite '%s'",luaL_checkstring(L,1));
    if (lua_toboolean(L,8)) {
        const auto color=imageColorRGBA(L,4);
        sprite->SetBlendMode(TranslateBlendMode(L,3));sprite->SetColor(color);
    }
    // 保留 GetAttr(rot) 转为角度再由 Render 转回弧度的舍入过程。
    volatile double degrees=object->rot*L_RAD_TO_DEG;
    const auto scale=LRES.GetGlobalImageScaleFactor();
    sprite->Render(static_cast<float>(object->x),static_cast<float>(object->y),
        static_cast<float>(degrees*L_DEG_TO_RAD),static_cast<float>(object->hscale)*scale,
        static_cast<float>(object->vscale)*scale,0.5f);
    return 0;
}
static int create(lua_State* L) {
    const char* texture=lua_isnoneornil(L,1) ? nullptr:luaL_checkstring(L,1);luaL_checktype(L,2,LUA_TTABLE);
    const size_t count=lua_objlen(L,2);
    if (!count || count%15 || count/5>UINT32_MAX) return luaL_error(L,"原作网格顶点表不完整或过大");
    auto* out=new(lua_newuserdata(L,sizeof(Mesh))) Mesh();
    if (luaL_newmetatable(L,type_name)) {
        lua_pushcfunction(L,[](lua_State* s) { static_cast<Mesh*>(luaL_checkudata(s,1,type_name))->~Mesh();return 0; });
        lua_setfield(L,-2,"__gc");
    }
    lua_setmetatable(L,-2);
    try {
        if (texture) {
            auto resource=LAPP.GetResourceMgr().FindTexture(texture);
            if (!resource) throw std::runtime_error("原作网格纹理缺失");
            out->texture=resource->GetTexture();
        }
        auto* device=LAPP.getGraphicsDevice();
        static std::weak_ptr<Pipeline> cached;
        out->pipeline=cached.lock();
        if (!out->pipeline || out->pipeline->device.get()!=device) {
            out->pipeline=std::make_shared<Pipeline>(device);cached=out->pipeline;
        }
        out->pipeline->ensure();
        std::vector<std::array<float,5>> vertices;std::vector<uint32_t> indices;
        std::unordered_map<VertexKey,uint32_t,VertexHash> unique;
        indices.reserve(count/5);
        for (size_t i=0;i<count;i+=5) {
            std::array<float,5> v{};for (int j=0;j<5;++j) v[j]=number(L,2,i+j+1);
            VertexKey key{};std::memcpy(key.bits.data(),v.data(),sizeof(v));
            auto const [it,inserted]=unique.emplace(key,static_cast<uint32_t>(vertices.size()));
            if (inserted) vertices.push_back(v);
            indices.push_back(it->second);
        }
        core::Graphics::MeshOptions options;
        options.vertex_count=static_cast<uint32_t>(vertices.size());options.index_count=static_cast<uint32_t>(indices.size());
        options.vertex_index_compression=vertices.size()<=65535;
        if (!core::Graphics::IMesh::create(device,options,out->data.put())) throw std::runtime_error("创建原作 GPU 网格失败");
        for (uint32_t i=0;i<options.vertex_count;++i) {
            auto const& v=vertices[i];out->data->setVertex(i,core::Vector3F(v[0],v[1],v[2]),core::Vector2F(v[3],v[4]),core::Color4B(0xffffffff));
        }
        for (uint32_t i=0;i<options.index_count;++i) out->data->setIndex(i,indices[i]);
        if (!out->data->commit()) throw std::runtime_error("上传原作 GPU 网格失败");
        // 由 Mesh 保留原始数据，以便设备重建时恢复；正常绘制不再提交顶点。
    } catch (std::exception const& e) { return luaL_error(L,"%s",e.what()); }
    return 1;
}
struct Command {
    Mesh* mesh{};
    std::array<float,36> constants{};
    uint32_t blend{},depth{},cull{};
};
static void readCommand(lua_State* L,int base,Command& out) {
    out={};out.mesh=static_cast<Mesh*>(luaL_checkudata(L,base+1,type_name));
    luaL_checktype(L,base+2,LUA_TTABLE);auto const color=*binding::Color::Cast(L,base+3);
    luaL_checktype(L,base+4,LUA_TTABLE);
    const auto blend=luaL_checkinteger(L,base+5),depth=luaL_checkinteger(L,base+6),cull=luaL_checkinteger(L,base+8);
    if (blend<1 || blend>4 || depth<0 || depth>2 || cull<0 || cull>2) throw std::runtime_error("原作网格材质状态无效");
    out.blend=static_cast<uint32_t>(blend-1);out.depth=static_cast<uint32_t>(depth);out.cull=static_cast<uint32_t>(cull);
    auto& a=out.constants;
    for (int col=0;col<3;++col) for (int row=0;row<3;++row) a[col*4+row]=number(L,base+2,col*3+row+1);
    for (int row=0;row<3;++row) a[12+row]=number(L,base+2,10+row);
    a[15]=1;
    for (int i=0;i<4;++i) a[16+i]=number(L,base+4,i+1);
    a[20]=color.r/255.f;a[21]=color.g/255.f;a[22]=color.b/255.f;a[23]=color.a/255.f;
    a[24]=lua_toboolean(L,base+7) ? 200.f/255.f:0;
    // 1/2 保留 XNA 混合；3/4 对齐 Sub 的纹理反预乘、着色、雾与最终预乘。
    a[26]=blend>=3 ? 1.f:0.f;
    a[27]=!out.mesh->texture ? 2.f:out.mesh->texture->isPremultipliedAlpha() ? 1.f:0.f;
    if (lua_istable(L,base+9)) {
        a[28]=number(L,base+9,1);a[29]=number(L,base+9,2);
        a[25]=a[28]!=a[29] ? 1.f:0.f;
        for (int i=0;i<3;++i) a[32+i]=number(L,base+9,3+i);
        a[30]=number(L,base+9,6);a[31]=number(L,base+9,7);a[35]=number(L,base+9,8);
    }
}
static bool sameMaterial(Command const& a,Command const& b) {
    return a.mesh==b.mesh && a.blend==b.blend && a.depth==b.depth && a.cull==b.cull;
}
static void submit(Command const* commands,size_t count) {
    if (!count) return;
    auto* renderer=LAPP.getRenderer2D();
    if (!renderer->isBatchScope()) throw std::runtime_error("原作网格绘制必须在 BeginScene 内");
    auto& p=*commands[0].mesh->pipeline;p.ensure();
    if (!renderer->flush()) throw std::runtime_error("提交原作网格前刷新批次失败");
    auto* cmd=p.device->getCommandbuffer();auto* ctx=static_cast<ID3D11DeviceContext*>(cmd->getNativeHandle());
    SavedState saved(ctx);
    // 只合并相邻的同网格、同状态实例，保持所有透明表面的提交顺序。
    for (size_t first=0;first<count;) {
        size_t end=first+1;
        while (end<count && end-first<128 && sameMaterial(commands[first],commands[end])) ++end;
        auto const& draw=commands[first];auto* mesh=draw.mesh;
        if (mesh->pipeline.get()!=&p) throw std::runtime_error("同批网格来自不同图形设备");
        D3D11_MAPPED_SUBRESOURCE mapped{};
        check(ctx->Map(p.constants.Get(),0,D3D11_MAP_WRITE_DISCARD,0,&mapped),"更新原作网格参数失败");
        auto* dst=static_cast<uint8_t*>(mapped.pData);
        for (size_t i=first;i<end;++i) std::memcpy(dst+(i-first)*144,commands[i].constants.data(),144);
        ctx->Unmap(p.constants.Get(),0);
        auto* native=static_cast<core::Graphics::Direct3D11::Mesh*>(mesh->data.get());
        native->applyNative(ctx,false);
        ctx->VSSetShader(p.vs.Get(),nullptr,0);ctx->PSSetShader(p.ps.Get(),nullptr,0);
        auto* cb=p.constants.Get();ctx->VSSetConstantBuffers(1,1,&cb);ctx->PSSetConstantBuffers(1,1,&cb);
        cmd->bindPixelShaderTexture2D(0,mesh->texture.get());
        auto* sampler=mesh->texture ? mesh->texture->getSamplerState():nullptr;
        if (!sampler) sampler=renderer->getKnownSamplerState(core::Graphics::IRenderer::SamplerState::LinearWrap);
        cmd->bindPixelShaderSampler(0,sampler);
        ctx->OMSetBlendState(p.blends[draw.blend].Get(),nullptr,0xffffffff);
        ctx->OMSetDepthStencilState(p.depths[draw.depth].Get(),0);ctx->RSSetState(p.rasters[draw.cull].Get());
        cmd->drawIndexedInstanced(mesh->data->getIndexCount(),static_cast<uint32_t>(end-first),0,0,0);
        first=end;
    }
}
static int draw(lua_State* L) {
    try {
        Command command;readCommand(L,0,command);submit(&command,1);
    } catch (std::exception const& e) { return luaL_error(L,"%s",e.what()); }
    return 0;
}
static int drawBatch(lua_State* L) {
    luaL_checktype(L,1,LUA_TTABLE);
    const size_t count=lua_objlen(L,1);
    static thread_local std::vector<Command> commands;
    try {
        commands.resize(count);
        // 全部 Lua 参数先解析，进入绘制阶段后只执行 C++，异常由 SavedState 还原。
        for (size_t i=0;i<count;++i) {
            lua_rawgeti(L,1,static_cast<int>(i+1));const int row=lua_gettop(L);
            luaL_checktype(L,row,LUA_TTABLE);
            for (int j=1;j<=9;++j) lua_rawgeti(L,row,j);
            readCommand(L,row,commands[i]);lua_settop(L,row-1);
        }
        submit(commands.data(),commands.size());
    } catch (std::exception const& e) { return luaL_error(L,"%s",e.what()); }
    return 0;
}
}
