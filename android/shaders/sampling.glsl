// Sub v0.21.129 SamplerState 0..7：点/线性 × 循环、钳制、两种边界槽。
// 该版本BorderWhite仍复用默认黑边（Renderer_D3D11.cpp的TODO），保留实际行为。
// 在片元中处理边界及线性权重，使Metal/GLES一致且不改动源纹理的全局采样器。
uniform vec4 POSTFX_SAMPLER;
vec4 subReadTexel(vec2 p, float address) {
    vec2 size = SCREENSIZE.zw;
    if (address < 0.5) p = mod(p, size);
    else if (address > 1.5 && (p.x < 0.0 || p.y < 0.0 || p.x >= size.x || p.y >= size.y))
        return vec4(0.0);
    p = clamp(p, vec2(0.0), size-1.0);
    return texture2D(u_texture, (p+0.5)/size);
}
vec4 subSampleScreen(vec2 uv) {
    float state = POSTFX_SAMPLER.x;
    float address = mod(state, 4.0);
    if (state < 4.0) return subReadTexel(floor(uv*SCREENSIZE.zw), address);
    vec2 position = uv*SCREENSIZE.zw-0.5;
    vec2 p = floor(position);
    vec2 f = position-p;
    vec4 a = mix(subReadTexel(p, address), subReadTexel(p+vec2(1.0,0.0), address), f.x);
    vec4 b = mix(subReadTexel(p+vec2(0.0,1.0), address), subReadTexel(p+vec2(1.0,1.0), address), f.x);
    return mix(a, b, f.y);
}
