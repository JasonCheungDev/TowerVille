#define INVERSE_8_PI 0.0397887357729738339422209408431

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

uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform lowp vec4 u_SurfaceColor;

uniform sampler2D u_Texture;
uniform bool u_HasTexture;
uniform DirectionalLight u_DirectionalLight;
uniform PointLights u_PointLights[4];
uniform float u_SpecularPower;

attribute vec4 i_Position;
attribute vec2 i_TexCoord;
attribute vec3 i_Normal;

varying vec2 frag_TexCoord;
varying vec4 frag_Diffuse;
varying vec4 frag_Specular;

void main(void) {
    const vec3 cameraForward = vec3(0.0, 0.0, 1.0);
    const float attenuationCoef = 0.13;
    
    vec3 normal = normalize(mat3(u_ModelView) * i_Normal);
    vec3 position = (u_ModelView * i_Position).xyz;
    
    vec4 diffuse = vec4(0.0);
    vec4 specular = vec4(0.0);
    
    for (int i = 0; i < 2; i++) {
        vec3 lightDirection = u_PointLights[i].position - position;
        float lightDistance = length(lightDirection);
        lightDirection /= lightDistance;
        
        float halfLambert = dot(normal, lightDirection) * 0.5 + 0.5;
        
        vec3 halfDirection = normalize(cameraForward+lightDirection);
        float blinn = (2.0 + u_SpecularPower) * pow(max(0.0, dot(normal, halfDirection)), u_SpecularPower) * INVERSE_8_PI;
        
        float attenuation = 1.0 / (lightDistance * attenuationCoef);
        attenuation *= attenuation * u_PointLights[i].intensity;
        
        diffuse += u_PointLights[i].color * attenuation * halfLambert * halfLambert;
        specular += u_PointLights[i].color * attenuation * blinn;
    }
    
    frag_TexCoord = i_TexCoord;
    frag_Diffuse = diffuse * u_SurfaceColor;
    frag_Specular = specular;
    gl_Position = u_Projection * u_ModelView * i_Position;
}

