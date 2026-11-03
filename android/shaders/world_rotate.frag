// 逐式对应shader/world_rotate.hlsl，保留原文件vscale/hscale的参数顺序。
precision highp float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
uniform vec4 user_data_1;
varying vec2 v_texCoord;
void main() {
    vec2 center = user_data_0.xy;
    vec2 delta = v_texCoord * SCREENSIZE.zw - center;
    vec2 xy2 = center;
    if (abs(user_data_0.z) > 0.001) xy2.x = center.x + delta.x / user_data_0.z;
    if (abs(user_data_0.w) > 0.001) xy2.y = center.y + delta.y / user_data_0.w;
    vec2 d = xy2 - center;
    float angle = radians(user_data_1.x);
    vec2 tr = vec2(cos(angle), sin(angle));
    vec2 xy3 = vec2(d.x*tr.x - d.y*tr.y, d.x*tr.y + d.y*tr.x) + center;
    if (xy3.x < VIEWPORT.x || xy3.x > VIEWPORT.z || xy3.y < VIEWPORT.y || xy3.y > VIEWPORT.w) discard;
    vec4 c = texture2D(u_texture, xy3 / SCREENSIZE.zw);
    c.a = 1.0;
    gl_FragColor = c;
}
