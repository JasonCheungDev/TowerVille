#version 300 es

precision mediump float;

// Note: when implementing these structs please ensure the EXACT order AND name are used, as how the info is being passed to opengl may change.
struct DirectionalLight
{
    mediump float intensity;
    mediump vec3 direction;
    mediump vec4 color;
};

// Note: position is in WORLD space. If you need me to separate the ModelView matrix into Model and View msg me.
struct PointLights
{
    mediump float intensity;
    mediump vec3 position;
    mediump vec4 color;
};

uniform sampler2D u_Texture;    // sampler3D also exists
uniform DirectionalLight u_DirectionalLight;
uniform PointLights[4] u_PointLights;
uniform highp mat4 u_ModelView;

in lowp vec4 frag_Color;
in lowp vec2 frag_TexCoord;
in lowp vec3 frag_Normal;
in lowp vec3 frag_Position;

out lowp vec4 o_color;

void main()
{
    vec3 debugLightPosition = vec3(7.07107, 4.08248, -14.4338); // (5,-5,5) worldspace

    // diffuse lighting
    mediump float diffuseFactor = max(-dot(normalize(frag_Normal), normalize(u_DirectionalLight.direction)), 0.0);
    mediump float halfLambertFactor = pow(diffuseFactor * 0.5 + 0.5, 2.0);
    mediump vec4 diffuseColor = frag_Color * halfLambertFactor;
    
    diffuseColor = vec4(0,0,0,1);   // set surface to black to see light changes
    
    // point lights
    for (int i = 0; i < 4; i++)
    {
        vec3 lightDirection = u_PointLights[i].position - frag_Position;
        vec3 halfDirection = normalize(vec3(0.0, 0.0, 1.0)+normalize(lightDirection));
        
        float halfLambert = pow(dot(frag_Normal, normalize(lightDirection)) * 0.5 + 0.5, 2.0);
        float blinn = pow(max(0.0, dot(frag_Normal, halfDirection)), 10.0);
        float attenuation = 1.0 / pow(length(lightDirection) * 0.4, 2.0);
        
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
