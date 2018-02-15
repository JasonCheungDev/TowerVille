#version 300 es

uniform sampler2D u_Texture;    // sampler3D also exists

in lowp vec4 frag_Color;
in lowp vec2 frag_TexCoord;
in lowp vec3 frag_Normal;
in lowp vec3 frag_Position;

out lowp vec4 o_color;

void main()
{
    lowp vec3 debugLightDirection = vec3(-1,-1,-1);

    mediump float diffuseFactor = max(-dot(normalize(frag_Normal), normalize(debugLightDirection)), 0.0);
    mediump float halfLambertFactor = pow(diffuseFactor * 0.5 + 0.5, 2.0);
    mediump vec4 diffuseColor = frag_Color * halfLambertFactor;
    diffuseColor.a = 1.0f;
    
    ivec2 texSize = textureSize(u_Texture, 0);
    if (texSize.x == 0)
    {
        o_color = diffuseColor;
    }
    else
    {
        o_color = texture(u_Texture, frag_TexCoord) * diffuseColor;
    }
}
