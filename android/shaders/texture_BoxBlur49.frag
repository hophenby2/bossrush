precision mediump float;
uniform sampler2D u_texture;
uniform vec4 SCREENSIZE;
uniform vec4 VIEWPORT;
uniform vec4 user_data_0;
varying vec2 v_texCoord;
void main() {
    vec2 size = SCREENSIZE.zw;
    vec2 position = v_texCoord * size;
    float radius = user_data_0.x * size.y / 480.0;
    vec4 c = vec4(0.0);
    // 双线性过滤配合 3×3 tent 核，保留柔化效果，将每像素采样从 49 次降至 9 次。
    for (int x=-1;x<=1;++x) {
        for (int y=-1;y<=1;++y) {
            float weight = (x==0 ? 2.0 : 1.0) * (y==0 ? 2.0 : 1.0);
            vec2 p = clamp(position+vec2(float(x),float(y))*radius*0.8, VIEWPORT.xy+0.5, VIEWPORT.zw-0.5);
            c += texture2D(u_texture, p/size)*weight;
        }
    }
    gl_FragColor = vec4((c/16.0).rgb,1.0);
}
