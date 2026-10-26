// 使用 LuaSTG-x 的属性名与矩阵绑定，供 GLES 后处理共享。
attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord;
uniform mat4 u_MVPMatrix;
varying mediump vec2 v_texCoord;
varying lowp vec4 v_fragmentColor;
void main() {
    gl_Position = u_MVPMatrix * a_position;
    v_texCoord = a_texCoord;
    v_fragmentColor = a_color;
}
