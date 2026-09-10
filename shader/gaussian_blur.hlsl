// 高斯模糊效果
//
// code by CHU for DFLYT
// port to LuaSTG-Sub by 璀境石
// 本代码由木神倾情提供。

// 引擎设置的参数，不可修改

SamplerState screen_texture_sampler : register(s4); // RenderTarget 纹理的采样器
Texture2D screen_texture            : register(t4); // RenderTarget 纹理
cbuffer engine_data : register(b1)
{
	float4 screen_texture_size; // 纹理大小
	float4 viewport;            // 视口
};

// 用户传递的浮点参数
// 由多个 float4 组成，且 float4 是最小单元，最多可传递 8 个 float4

cbuffer user_data : register(b0)
{
	float4 user_data_0;
	float4 user_data_1;
	float4 user_data_2;
};

// 为了方便使用，定义的一些宏

#define screenSize screen_texture_size.xy
// 模糊强度，默认 100.0f
#define sigma user_data_0.x
#define Ax    user_data_1.x
#define Bx    user_data_1.y
#define Cx    user_data_1.z
#define Dx    user_data_1.w
#define Ay    user_data_2.x
#define By    user_data_2.y
#define Cy    user_data_2.z
#define Dy    user_data_2.w

// 函数

float Gaussain(float sigma_v, float alpha)
{
	return exp(-(alpha * alpha) / (2.0f * sigma_v * sigma_v + 0.00001f));
}

bool ifinbox(float2 p1,float2 p2,float2 p4,float2 p0)
{
	float2 V1 = p2-p1;
	float2 V2 = p4-p1;
	float2 V3 = p0-p1;
	float D1 = dot(V1,V3);
	float D2 = dot(V2,V3);
	float D3 = dot(V1,V1);
	float D4 = dot(V2,V2);
	return (D1 > 0.0f && D1 < D3 && D2 > 0.0f && D2 < D4);
}

// 主函数

struct PS_Input
{
	float4 sxy : SV_Position;
	float2 uv  : TEXCOORD0;
	float4 col : COLOR0;
};
struct PS_Output
{
	float4 col : SV_Target;
};

PS_Output main(PS_Input input)
{
	float2 uvReal = input.uv * screenSize; // 屏幕上真实位置
	float totalWeight = 0.0f;
	float4 totalColor1 = float4(0.0f, 0.0f, 0.0f, 0.0f);
	if (ifinbox(float2(Ax, Ay), float2(Bx, By), float2(Dx, Dy), uvReal))
	{
		totalColor1 = screen_texture.Sample(screen_texture_sampler, input.uv);
	}
	else
	{
		totalColor1 = screen_texture.Sample(screen_texture_sampler, input.uv) / 4.0f;
		totalColor1.a = 1.0f;
	}

	PS_Output output;
	output.col = totalColor1;
	return output;
}
