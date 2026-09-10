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

#define screenSize   screen_texture_size.xy
#define screenHeight screen_texture_size.y
#define center       user_data_0.xy
#define centerx      user_data_0.x
#define centery      user_data_0.y
// 默认 float4(1.0, 0.0, 0.0, 1.0)
#define color        user_data_1
#define size         user_data_2.x
#define arg          user_data_2.y
#define timer        user_data_2.z

// 函数

float4 multiply(float4 base, float4 blend, float powerRatio, float waveRadius_Circle)
{
	float4 c = float4(
		base.r *(1.0f - (1.0f - blend.r) * 2.0f * powerRatio - waveRadius_Circle*powerRatio / 32.0f);
		base.g *(1.0f - (1.0f - blend.g) * 2.0f * powerRatio - waveRadius_Circle*powerRatio / 32.0f);
		base.b *(1.0f - (1.0f - blend.b) * 2.0f * powerRatio - waveRadius_Circle*powerRatio / 32.0f);
		base.a; // 1.0-(1.0-base.a)*(1.0-blend.a);
	);
	return c;
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
	float2 xy = uv * screenSize;
	if (xy.x < viewport.x || xy.x > viewport.z || xy.y < viewport.y || xy.y > viewport.w)
	{
		discard; // 抛弃不需要的像素，防止意外覆盖画面
	}

	float rate = screenHeight / 512.0f;
	float2 xy2 = xy;
	float2 delta = xy - center;
	float len = length(delta);
	float inner = 0.5f;
	float2 uv2 = uv;
	
	float dist = sqrt((centerx-xy.x+0.5f)*(centerx-xy.x+0.5f) + (centery-xy.y+0.5f)*(centery-xy.y+0.5f)+size);
	float distY = centery - xy.y + 0.5f;
	float cosTheta = (xy.x - centerx) / dist;
	float sinTheta = (xy.y - centery) / dist;
	
	float angle  = max(0.0f,centery - xy.y) + max(0.0f,centerx - xy.x) - timer * -5.0f;
	float angle2 = centery - xy.y + centerx - xy.x - timer * -5.0f;
	angle = radians(angle);
	angle2 = radians(angle2 * 1.0f);
	
	float size2 = size * rate;
	
	float powerRatio = ( size2 - dist) / size2;
	powerRatio = clamp(powerRatio, 0.0f, 0.6f);
	float powerRatio2 = ( size2 - dist) / size2;
	powerRatio2 = clamp(powerRatio2, 0.0f, 1.0f);
	
	float waveRadius_Circle = pow(powerRatio, 0.5f) * 1.2f + sin(angle2) + exp(pow((1.5f, dist) * 5.0f, 2.0f) * (-3.14f));
	
	float waveRadius = size * waveRadius_Circle;
	
	float biasRadiusX = -min(dist * 0.2f, 8.0f) - abs(cos(angle2) * waveRadius / 2.0f * (1.0f / 8.0f - powerRatio / 8.0f)) * powerRatio - 4.0f;
	float biasRadiusY = -min(dist * 0.2f, 8.0f) - abs(sin(angle2) * waveRadius / 2.0f * (1.0f / 8.0f - powerRatio / 8.0f)) * powerRatio - 4.0f;
	float biasX = biasRadiusX * cosTheta*powerRatio * 2.0f;
	float biasY = biasRadiusY * sinTheta*powerRatio * 2.0f;
	
	float2 posm;
	posm.x = biasX / 512.0f + uv.x;
	posm.y = biasY / 512.0f + uv.y;
	posm.y = posm.y + sin(angle2) * (pow(powerRatio, 0.5f)) / 64.0f;
	
	float2 xy3 = posm * screenSize;
	
	//限制uv坐标的取值
	xy3 = float2(clamp(xy3.x, viewport.x + 1.0f, viewport.z - 1.0f), clamp(xy3.y, viewport.y + 1.0f, viewport.w - 1.0f));
	float2 uv3 = xy3 / screenSize;
	float4 texColor = screen_texture.Sample(screen_texture_sampler, uv3);
	float4 texColor2 = texColor;
	if (len < size2)
	{
		texColor = multiply(texColor, color, powerRatio2, waveRadius_Circle);
	}
	texColor.a = 1.0f;

	PS_Output output;
	output.col = texColor;
	return output;
}
