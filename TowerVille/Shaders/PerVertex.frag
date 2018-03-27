precision mediump float;

uniform sampler2D u_Texture;
uniform bool u_HasTexture;

varying lowp vec4 frag_Diffuse;
varying lowp vec4 frag_Specular;
varying lowp vec2 frag_TexCoord;

void main() {
    vec4 diffuseColor = frag_Diffuse;
    if (u_HasTexture) {
        diffuseColor *= texture2D(u_Texture, frag_TexCoord) * texture2D(u_Texture, frag_TexCoord);
    }
    gl_FragColor = diffuseColor + frag_Specular;
}
