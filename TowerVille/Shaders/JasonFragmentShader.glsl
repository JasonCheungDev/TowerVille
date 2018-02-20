#version 300 es

precision mediump float;

struct DirectionalLight
{
    mediump float intensity;
    mediump vec3 direction;
    mediump vec4 color;
};

struct PointLights
{
    mediump float intensity;
    mediump vec3 position;
    mediump vec4 color;
};

uniform sampler2D u_Texture;    // sampler3D also exists
uniform DirectionalLight u_DirectionalLight;
uniform PointLights[4] u_PointLights;

in lowp vec4 frag_Color;
in lowp vec2 frag_TexCoord;
in lowp vec3 frag_Normal;
in lowp vec3 frag_Position;

out lowp vec4 o_color;

void main()
{
    // diffuse lighting
    mediump float diffuseFactor = max(-dot(normalize(frag_Normal), normalize(u_DirectionalLight.direction)), 0.0);
    mediump float halfLambertFactor = pow(diffuseFactor * 0.5 + 0.5, 2.0);
    mediump vec4 diffuseColor = frag_Color * halfLambertFactor;
    
    diffuseColor = vec4(0,0,0,1);
    
    // point lights
    for (int i = 0; i < 4; i++)
    {
        float dist = distance(frag_Position, u_PointLights[i].position);
        float attenuation = 1.0 / (1.0 + 0.05 * pow(dist,2.0));
        diffuseColor = diffuseColor + attenuation * u_PointLights[i].color;
    }
    
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
