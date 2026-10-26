// 原版此 shader 实际执行矩形摄影区域遮罩，保留该行为。
precision mediump float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 user_data_1;
uniform vec4 user_data_2;
varying vec2 v_texCoord;
void main() {
    vec2 p = v_texCoord * SCREENSIZE.zw;
    vec2 a = vec2(user_data_1.x, user_data_2.x);
    vec2 u = vec2(user_data_1.y, user_data_2.y)-a;
    vec2 v = vec2(user_data_1.w, user_data_2.w)-a;
    vec2 w = p-a;
    bool inside = dot(u,w)>0.0 && dot(u,w)<dot(u,u) && dot(v,w)>0.0 && dot(v,w)<dot(v,v);
    vec4 c = texture2D(u_texture, v_texCoord);
    if (!inside) { c *= 0.25; c.a=1.0; }
    gl_FragColor = c;
}
