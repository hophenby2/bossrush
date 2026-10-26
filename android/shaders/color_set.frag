precision mediump float;
uniform sampler2D u_texture;
uniform vec4 user_data_0;
varying vec2 v_texCoord;
float hue(float v1, float v2, float h) {
    h = fract(h);
    if (6.0 * h < 1.0) return v1 + (v2-v1)*6.0*h;
    if (2.0 * h < 1.0) return v2;
    if (3.0 * h < 2.0) return v1 + (v2-v1)*(2.0/3.0-h)*6.0;
    return v1;
}
vec3 hsl(float h, float s, float l) {
    float v2 = l < 0.5 ? l*(1.0+s) : l+s-s*l;
    float v1 = 2.0*l-v2;
    return vec3(hue(v1,v2,h+1.0/3.0), hue(v1,v2,h), hue(v1,v2,h-1.0/3.0));
}
void main() {
    vec4 c = texture2D(u_texture, v_texCoord);
    if (user_data_0.z >= 0.99) {
        float l = dot(c.rgb, vec3(0.299,0.587,0.114));
        c.rgb = hsl(user_data_0.x, 1.0-l, l);
    }
    if (user_data_0.y <= 0.99) c.a = 1.0;
    gl_FragColor = c;
}
