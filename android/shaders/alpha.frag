precision mediump float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
varying vec2 v_texCoord;
void main() {
    vec2 p = v_texCoord * SCREENSIZE.zw;
    if (p.x < VIEWPORT.x || p.x > VIEWPORT.z || p.y < VIEWPORT.y || p.y > VIEWPORT.w) discard;
    vec4 c = texture2D(u_texture, v_texCoord);
    c.a = min(c.a * 3.333, 1.0);
    gl_FragColor = c;
}
