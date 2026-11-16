// 与 Windows 后端共用六层反色波参数。
precision highp float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
uniform vec4 user_data_1;
varying vec2 v_texCoord;
vec3 ring(vec3 color, float distance) {
    return mix(vec3(1.0) - color, color, clamp(distance / user_data_1.w, 0.0, 1.0));
}
void main() {
    vec2 xy = v_texCoord * SCREENSIZE.zw;
    if (any(lessThan(xy, VIEWPORT.xy)) || any(greaterThan(xy, VIEWPORT.zw))) discard;
    vec2 d = ((xy - VIEWPORT.xy) / (VIEWPORT.zw - VIEWPORT.xy) - user_data_0.xy)
             * vec2(user_data_0.w, user_data_1.x);
    float r = user_data_0.z;
    vec3 c = texture2D(u_texture, v_texCoord).rgb;
    c = ring(c, length(d) - r);
    c = ring(c, length(d + vec2(user_data_1.y, 0.0)) - r + 0.05);
    c = ring(c, length(d - vec2(user_data_1.y, 0.0)) - r + 0.05);
    c = ring(c, length(d + vec2(0.0, user_data_1.z)) - r + 0.05);
    c = ring(c, length(d - vec2(0.0, user_data_1.z)) - r + 0.05);
    c = ring(c, length(d) - r + 0.6);
    gl_FragColor = vec4(c, 1.0);
}
