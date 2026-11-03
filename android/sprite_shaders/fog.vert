// 位置先按世界坐标插值；雾距离在片元阶段计算，对齐Sub v0.21.129。
precision highp float;
#if __VERSION__ >= 300
layout(location=0) in vec4 a_position;
layout(location=1) in vec4 a_color;
layout(location=2) in vec2 a_texCoord;
layout(std140, binding=0) uniform VSBlock { mat4 u_MVPMatrix; };
layout(location=0) out highp vec4 v_fragmentColor;
layout(location=1) out highp vec2 v_texCoord;
layout(location=2) out highp vec3 v_worldPosition;
#else
attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord;
uniform mat4 u_MVPMatrix;
varying highp vec4 v_fragmentColor;
varying highp vec2 v_texCoord;
varying highp vec3 v_worldPosition;
#endif
void main() {
    gl_Position = u_MVPMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
    v_worldPosition = a_position.xyz;
}
