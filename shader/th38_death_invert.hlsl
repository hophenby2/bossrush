// 雪莲华掉命时，以自机为中心向外扩展六层反色波。
SamplerState screen_sampler : register(s4);
Texture2D screen_texture : register(t4);
cbuffer engine_data : register(b1) { float4 screen_texture_size; float4 viewport; };
cbuffer user_data : register(b0) { float4 user_data_0; float4 user_data_1; };
struct Input { float4 pos : SV_Position; float2 uv : TEXCOORD0; float4 color : COLOR0; };
float3 ring(float3 color, float distance)
{
    return lerp(1.0 - color, color, saturate(distance / user_data_1.w));
}
float4 main(Input input) : SV_Target
{
    float2 xy = input.uv * screen_texture_size.xy;
    if (any(xy < viewport.xy) || any(xy > viewport.zw)) discard;
    float2 d = ((xy - viewport.xy) / (viewport.zw - viewport.xy) - user_data_0.xy)
               * float2(user_data_0.w, user_data_1.x);
    float r = user_data_0.z;
    float3 c = screen_texture.Sample(screen_sampler, input.uv).rgb;
    c = ring(c, length(d) - r);
    c = ring(c, length(d + float2(user_data_1.y, 0.0)) - r + 0.05);
    c = ring(c, length(d - float2(user_data_1.y, 0.0)) - r + 0.05);
    c = ring(c, length(d + float2(0.0, user_data_1.z)) - r + 0.05);
    c = ring(c, length(d - float2(0.0, user_data_1.z)) - r + 0.05);
    c = ring(c, length(d) - r + 0.6);
    return float4(c, 1.0);
}
