precision mediump float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
varying vec2 v_texCoord;
void main() {
    vec2 p = v_texCoord * SCREENSIZE.zw;
    if (p.x < VIEWPORT.x || p.x > VIEWPORT.z || p.y < VIEWPORT.y || p.y > VIEWPORT.w) discard;
    vec4 c = texture2D(u_texture, v_texCoord);
    float l = dot(c.rgb, vec3(0.299, 0.587, 0.114));
    gl_FragColor = vec4(mix(c.rgb, vec3(l), user_data_0.x), user_data_0.y > 0.99 ? c.a : 1.0);
}
