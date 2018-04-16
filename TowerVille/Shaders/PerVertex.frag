precision mediump float;

uniform sampler2D u_Texture;
uniform bool u_HasTexture;

varying lowp vec4 frag_Diffuse;
varying lowp vec4 frag_Specular;
varying lowp vec2 frag_TexCoord;

void main() {
    vec4 diffuseColor = frag_Diffuse;
    if (u_HasTexture) {
        diffuseColor *= texture2D(u_Texture, frag_TexCoord);
    }

    vec4 linearColor = diffuseColor + frag_Specular;
    
    // HORRIBLE GROSS DISGUSTING code to draw tile borders
    if (frag_TexCoord.x > 1.0 || frag_TexCoord.y > 1.0) {
        linearColor /= 2.0;
    }
    if (frag_TexCoord.x < 0.0 || frag_TexCoord.y < 0.0) {
        linearColor *= 2.0;
    }
    
    gl_FragColor = linearColor;
}
