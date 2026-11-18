#ifdef GL_ES
precision highp float;
precision highp sampler2D;
#endif
#if __VERSION__ >= 300
layout(binding=2) uniform sampler2D u_texture;
layout(location=0) in vec4 v_fragmentColor;
layout(location=1) in vec2 v_texCoord;
layout(location=0) out vec4 cc_FragColor;
#else
uniform sampler2D u_texture;
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif
void main() {
#if __VERSION__ >= 300
    vec4 color=texture(u_texture,v_texCoord)*v_fragmentColor;
    if (color.a<200.0/255.0) discard;
    cc_FragColor=color;
#else
    vec4 color=texture2D(u_texture,v_texCoord)*v_fragmentColor;
    if (color.a<200.0/255.0) discard;
    gl_FragColor=color;
#endif
}
