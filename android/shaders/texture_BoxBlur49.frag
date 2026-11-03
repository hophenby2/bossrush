// 与shader/texture_BoxBlur49.hlsl一致：49点等权采样，视口内缩1像素。
precision highp float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
varying vec2 v_texCoord;
float offsetAt(int i) {
    if (i == 0) return -1.0;
    if (i == 1) return -0.65;
    if (i == 2) return -0.35;
    if (i == 3) return 0.0;
    if (i == 4) return 0.35;
    if (i == 5) return 0.65;
    return 1.0;
}
vec4 sampleOffset(vec2 position, vec2 offset) {
    vec2 p = clamp(position + offset, VIEWPORT.xy + 1.0, VIEWPORT.zw - 1.0);
    return texture2D(u_texture, p / SCREENSIZE.zw);
}
void main() {
    vec2 p = v_texCoord * SCREENSIZE.zw;
    float radius = user_data_0.x * SCREENSIZE.w / 480.0;
    vec4 c = vec4(0.0);
    // 保留HLSL的累加顺序：负X三列、非负X三列、最右一列。
    for (int x = 0; x < 3; ++x)
        for (int y = 0; y < 7; ++y)
            c += sampleOffset(p, vec2(offsetAt(x), offsetAt(y)) * radius);
    for (int x = 3; x < 6; ++x)
        for (int y = 0; y < 7; ++y)
            c += sampleOffset(p, vec2(offsetAt(x), offsetAt(y)) * radius);
    for (int y = 0; y < 7; ++y)
        c += sampleOffset(p, vec2(1.0, offsetAt(y)) * radius);
    c /= 49.0;
    c.a = 1.0;
    gl_FragColor = c;
}
