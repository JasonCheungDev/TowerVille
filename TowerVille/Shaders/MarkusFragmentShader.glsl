#version 300 es

precision mediump float;

uniform sampler2D u_Texture;    // sampler3D also exists

in vec4 frag_Color;
in vec2 frag_TexCoord;
in vec3 frag_Normal;
in vec3 frag_Position;

out vec4 o_color;

void main()
{
    lowp vec4 debugLightColor = vec4(1.0, 1.0, 1.0, 1.0);
    vec3 debugLightPosition = vec3(7.07107, 4.08248, -14.4338); // (5,-5,5) worldspace
    
    vec3 lightDirection = debugLightPosition - frag_Position;
    vec3 halfDirection = normalize(vec3(0.0, 0.0, 1.0)+normalize(lightDirection));
    
    float halfLambert = pow(dot(frag_Normal, normalize(lightDirection)) * 0.5 + 0.5, 2.0);
    float blinn = pow(max(0.0, dot(frag_Normal, halfDirection)), 10.0);
    float attenuation = 1.0 / pow(length(lightDirection) * 0.2, 2.0);
    
    vec4 linearColor;
    if (textureSize(u_Texture, 0).x == 0) {
        linearColor = debugLightColor * attenuation * (blinn + halfLambert * frag_Color);
    } else {
        linearColor = debugLightColor * attenuation * (blinn + halfLambert * frag_Color * texture(u_Texture, frag_TexCoord));
    }
    
    o_color = sqrt(linearColor);
}
