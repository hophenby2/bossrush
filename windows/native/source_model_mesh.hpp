// 春雪原作网格：复用 Sub 的 GPU Mesh，逐次绘制只更新矩阵、UV 和材质参数。
#pragma once
#include <win32/base.hpp>
#include <d3d11.h>
#include "core/Graphics/Direct3D11/Mesh.hpp"
#include "LuaBinding/LuaWrapper.hpp"
#include "AppFrame.h"
#include <d3dcompiler.h>
#include <wrl/client.h>
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
cbuffer Model : register(b1) {
    float4x4 world;
    float4 uv_transform;
    float4 tint;
    float4 options;
};
Texture2D image : register(t0);
SamplerState image_sampler : register(s0);
struct Input { float3 position:POSITION0; float2 uv:TEXCOORD0; float4 color:COLOR0; };
struct Output { float4 position:SV_POSITION; float2 uv:TEXCOORD0; float4 color:COLOR0; };
Output vs_main(Input v) {
    Output o;
    o.position=mul(view_proj,mul(world,float4(v.position,1)));
    o.uv=v.uv*uv_transform.xy+uv_transform.zw;
    o.color=v.color*tint;
    return o;
}
float4 ps_main(Output v):SV_TARGET {
    float4 color=image.Sample(image_sampler,v.uv)*v.color;
    if (options.x>0) clip(color.a-options.x);
    return color;
}
)";
struct Pipeline final : core::IGraphicsDeviceEventListener {
    core::SmartReference<core::IGraphicsDevice> device;
    ComPtr<ID3D11VertexShader> vs;
    ComPtr<ID3D11PixelShader> ps;
    ComPtr<ID3D11Buffer> constants;
    ComPtr<ID3D11BlendState> blends[2];
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
        D3D11_BUFFER_DESC cb{};cb.ByteWidth=112;cb.Usage=D3D11_USAGE_DYNAMIC;
        cb.BindFlags=D3D11_BIND_CONSTANT_BUFFER;cb.CPUAccessFlags=D3D11_CPU_ACCESS_WRITE;
        check(d->CreateBuffer(&cb,nullptr,constants.GetAddressOf()),"创建原作网格参数缓冲区失败");
        for (int i=0;i<2;++i) {
            D3D11_BLEND_DESC b{};auto& rt=b.RenderTarget[0];rt.BlendEnable=TRUE;
            rt.SrcBlend=rt.SrcBlendAlpha=i ? D3D11_BLEND_SRC_ALPHA:D3D11_BLEND_ONE;
            rt.DestBlend=rt.DestBlendAlpha=i ? D3D11_BLEND_ONE:D3D11_BLEND_INV_SRC_ALPHA;
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
static int create(lua_State* L) {
    const char* texture=luaL_checkstring(L,1);luaL_checktype(L,2,LUA_TTABLE);
    const size_t count=lua_objlen(L,2);
    if (!count || count%15 || count/5>UINT32_MAX) return luaL_error(L,"原作网格顶点表不完整或过大");
    auto* out=new(lua_newuserdata(L,sizeof(Mesh))) Mesh();
    if (luaL_newmetatable(L,type_name)) {
        lua_pushcfunction(L,[](lua_State* s) { static_cast<Mesh*>(luaL_checkudata(s,1,type_name))->~Mesh();return 0; });
        lua_setfield(L,-2,"__gc");
    }
    lua_setmetatable(L,-2);
    try {
        auto resource=LAPP.GetResourceMgr().FindTexture(texture);
        if (!resource) throw std::runtime_error("原作网格纹理缺失");
        out->texture=resource->GetTexture();
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
static int draw(lua_State* L) {
    auto* mesh=static_cast<Mesh*>(luaL_checkudata(L,1,type_name));
    luaL_checktype(L,2,LUA_TTABLE);auto const color=*binding::Color::Cast(L,3);
    luaL_checktype(L,4,LUA_TTABLE);
    const auto blend=luaL_checkinteger(L,5),depth=luaL_checkinteger(L,6),cull=luaL_checkinteger(L,8);
    const bool cutout=lua_toboolean(L,7)!=0;
    if (blend<1 || blend>2 || depth<0 || depth>2 || cull<0 || cull>2) return luaL_error(L,"原作网格材质状态无效");
    auto* renderer=LAPP.getRenderer2D();
    if (!renderer->isBatchScope()) return luaL_error(L,"原作网格绘制必须在 BeginScene 内");
    try {
        // 12 项为三列线性变换和位移；按 Sub 着色器现有的矩阵布局上传。
        std::array<float,28> constants{};
        for (int col=0;col<3;++col) for (int row=0;row<3;++row) constants[col*4+row]=number(L,2,col*3+row+1);
        for (int row=0;row<3;++row) constants[12+row]=number(L,2,10+row);
        constants[15]=1;
        for (int i=0;i<4;++i) constants[16+i]=number(L,4,i+1);
        constants[20]=color.r/255.f;constants[21]=color.g/255.f;constants[22]=color.b/255.f;constants[23]=color.a/255.f;
        constants[24]=cutout ? 200.f/255.f:0;
        auto& p=*mesh->pipeline;p.ensure();
        if (!renderer->flush()) throw std::runtime_error("提交原作网格前刷新批次失败");
        auto* cmd=p.device->getCommandbuffer();auto* ctx=static_cast<ID3D11DeviceContext*>(cmd->getNativeHandle());
        SavedState saved(ctx);
        D3D11_MAPPED_SUBRESOURCE mapped{};
        check(ctx->Map(p.constants.Get(),0,D3D11_MAP_WRITE_DISCARD,0,&mapped),"更新原作网格参数失败");
        std::memcpy(mapped.pData,constants.data(),sizeof(constants));ctx->Unmap(p.constants.Get(),0);
        auto* native=static_cast<core::Graphics::Direct3D11::Mesh*>(mesh->data.get());
        native->applyNative(ctx,false);
        ctx->VSSetShader(p.vs.Get(),nullptr,0);ctx->PSSetShader(p.ps.Get(),nullptr,0);
        auto* cb=p.constants.Get();ctx->VSSetConstantBuffers(1,1,&cb);ctx->PSSetConstantBuffers(1,1,&cb);
        cmd->bindPixelShaderTexture2D(0,mesh->texture.get());
        auto* sampler=mesh->texture->getSamplerState();
        if (!sampler) sampler=renderer->getKnownSamplerState(core::Graphics::IRenderer::SamplerState::LinearWrap);
        cmd->bindPixelShaderSampler(0,sampler);
        ctx->OMSetBlendState(p.blends[blend-1].Get(),nullptr,0xffffffff);
        ctx->OMSetDepthStencilState(p.depths[depth].Get(),0);ctx->RSSetState(p.rasters[cull].Get());
        native->drawNative(ctx);
    } catch (std::exception const& e) { return luaL_error(L,"%s",e.what()); }
    return 0;
}
}
