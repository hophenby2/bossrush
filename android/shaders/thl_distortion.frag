// 逐式对应shader/thl_distortion.hlsl；原文件的语法残留在HLSL侧同步修正。
precision highp float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
uniform vec4 user_data_1;
uniform vec4 user_data_2;
varying vec2 v_texCoord;
vec4 multiplyColor(vec4 base, vec4 blend, float power, float wave) {
    return vec4(base.rgb * (vec3(1.0) - (vec3(1.0)-blend.rgb)*2.0*power - wave*power/32.0), base.a);
}
void main() {
    vec2 xy = v_texCoord * SCREENSIZE.zw;
    if (xy.x < VIEWPORT.x || xy.x > VIEWPORT.z || xy.y < VIEWPORT.y || xy.y > VIEWPORT.w) discard;
    vec2 center = user_data_0.xy;
    float size = user_data_2.x;
    vec2 delta = xy - center;
    float len = length(delta);
    float dist = sqrt((center.x-xy.x+0.5)*(center.x-xy.x+0.5) + (center.y-xy.y+0.5)*(center.y-xy.y+0.5) + size);
    float cosTheta = (xy.x-center.x)/dist;
    float sinTheta = (xy.y-center.y)/dist;
    float angle = radians(center.y-xy.y + center.x-xy.x - user_data_2.z*(-5.0));
    float size2 = size * (SCREENSIZE.w / 512.0);
    float power = clamp((size2-dist)/size2, 0.0, 0.6);
    float power2 = clamp((size2-dist)/size2, 0.0, 1.0);
    float wave = pow(power, 0.5)*1.2 + sin(angle) + exp(pow(dist*5.0, 2.0)*(-3.14));
    float radius = size * wave;
    float biasX = (-min(dist*0.2, 8.0) - abs(cos(angle)*radius/2.0*(1.0/8.0-power/8.0))*power - 4.0)*cosTheta*power*2.0;
    float biasY = (-min(dist*0.2, 8.0) - abs(sin(angle)*radius/2.0*(1.0/8.0-power/8.0))*power - 4.0)*sinTheta*power*2.0;
    vec2 uv = vec2(biasX/512.0, biasY/512.0) + v_texCoord;
    uv.y += sin(angle)*pow(power, 0.5)/64.0;
    vec2 p = clamp(uv*SCREENSIZE.zw, VIEWPORT.xy+1.0, VIEWPORT.zw-1.0);
    vec4 c = texture2D(u_texture, p/SCREENSIZE.zw);
    if (len < size2) c = multiplyColor(c, user_data_1, power2, wave);
    c.a = 1.0;
    gl_FragColor = c;
}
