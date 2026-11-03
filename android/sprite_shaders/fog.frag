// 0为顶点乘色，打包ColorAdd_Fog.frag时改为1。
#define SUB_COLOR_ADD 0
precision highp float;
precision highp sampler2D;
#if __VERSION__ >= 300
layout(std140, binding=1) uniform FSBlock {
    vec4 u_fogColor;
    vec4 u_fogCamera;
    float u_fogStart;
    float u_fogEnd;
    float u_fogDensity;
    float u_fogMode;
};
layout(binding=2) uniform sampler2D u_texture;
layout(location=0) in highp vec4 v_fragmentColor;
layout(location=1) in highp vec2 v_texCoord;
layout(location=2) in highp vec3 v_worldPosition;
layout(location=0) out vec4 cc_FragColor;
#else
uniform vec4 u_fogColor;
uniform vec4 u_fogCamera;
uniform float u_fogStart;
uniform float u_fogEnd;
uniform float u_fogDensity;
uniform float u_fogMode;
uniform sampler2D u_texture;
varying highp vec4 v_fragmentColor;
varying highp vec2 v_texCoord;
varying highp vec3 v_worldPosition;
#endif
void main() {
#if __VERSION__ >= 300
    vec4 tex = texture(u_texture, v_texCoord);
#else
    vec4 tex = texture2D(u_texture, v_texCoord);
#endif
#if SUB_COLOR_ADD
    vec4 c = vec4(min(tex.rgb + v_fragmentColor.rgb, vec3(1.0)), tex.a * v_fragmentColor.a);
#else
    vec4 c = tex * v_fragmentColor;
#endif
    float d = distance(u_fogCamera.xyz, v_worldPosition);
    float k;
    if (u_fogMode < 1.5) k = (d-u_fogStart)/(u_fogEnd-u_fogStart);
    else if (u_fogMode < 2.5) k = 1.0-exp(-(d*u_fogDensity));
    else k = 1.0-exp(-pow(d*u_fogDensity, 2.0));
    c = mix(c, vec4(u_fogColor.rgb, u_fogColor.a*c.a), clamp(k, 0.0, 1.0));
    // 移植层使用SRC_ALPHA混合；Sub输出预乘色配ONE混合，这里保持直通色避免重复乘alpha。
#if __VERSION__ >= 300
    cc_FragColor = c;
#else
    gl_FragColor = c;
#endif
}
