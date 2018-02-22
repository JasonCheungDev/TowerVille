#version 300 es
#define M_PI 3.1415926535897932384626433832795

precision mediump float;

struct DirectionalLight {
    mediump float intensity;
    mediump vec3 direction;
    mediump vec4 color;
};

struct PointLights {
    mediump float intensity;
    mediump vec3 position;
    mediump vec4 color;
};

uniform sampler2D u_Texture;
uniform DirectionalLight u_DirectionalLight;
uniform PointLights[4] u_PointLights;
uniform highp mat4 u_ModelView;

in lowp vec4 frag_Color;
in lowp vec2 frag_TexCoord;
in lowp vec3 frag_Normal;
in lowp vec3 frag_Position;

out lowp vec4 o_color;

void main() {
    float attenuationCoef = 0.15;
    float specularPower = 32.0;
    
    vec3 normal = normalize(frag_Normal);
    
    vec3 halfDirection = normalize(vec3(0.0, 0.0, 1.0)+normalize(-u_DirectionalLight.direction));
    float halfLambert = pow(dot(normal, normalize(-u_DirectionalLight.direction)) * 0.5 + 0.5, 2.0);
    float blinn = (2.0 + specularPower) * pow(max(0.0, dot(normal, halfDirection)), specularPower) / (8.0 * M_PI);
    
    vec4 diffuse = u_DirectionalLight.color * u_DirectionalLight.intensity * halfLambert;
    vec4 specular = u_DirectionalLight.color * u_DirectionalLight.intensity * blinn;
    
    for (int i = 0; i < 2; i++) {
        vec3 lightDirection = u_PointLights[i].position - frag_Position;
        vec3 halfDirection = normalize(vec3(0.0, 0.0, 1.0)+normalize(lightDirection));
        
        float halfLambert = pow(dot(frag_Normal, normalize(lightDirection)) * 0.5 + 0.5, 2.0);
        float blinn = (2.0 + specularPower) * pow(max(0.0, dot(frag_Normal, halfDirection)), specularPower) / (8.0 * M_PI);
        float attenuation = u_PointLights[i].intensity / pow(length(lightDirection) * attenuationCoef, 2.0);
        
        diffuse += u_PointLights[i].color * attenuation * halfLambert;
        specular += u_PointLights[i].color * attenuation * blinn;
    }
    
    if (textureSize(u_Texture, 0).x != 0) {
        diffuse *= texture(u_Texture, frag_TexCoord);
    }
    
    vec4 linearColor = diffuse * frag_Color + specular;
    o_color = sqrt(linearColor);
}
