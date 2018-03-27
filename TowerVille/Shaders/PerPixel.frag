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

uniform sampler2D u_Texture;
uniform bool u_HasTexture;
uniform DirectionalLight u_DirectionalLight;
uniform PointLights u_PointLights[4];
uniform highp mat4 u_ModelView;
uniform float u_SpecularPower;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

// out lowp vec4 o_color;

void main() {
    const vec3 cameraForward = vec3(0.0, 0.0, 1.0);
    const float attenuationCoef = 0.13;
    
    vec3 normal = normalize(frag_Normal);
    
    /*
     vec3 halfDirection = normalize(vec3(0.0, 0.0, 1.0)+normalize(-u_DirectionalLight.direction));
     float halfLambert = pow(dot(normal, normalize(-u_DirectionalLight.direction)) * 0.5 + 0.5, 2.0);
     float blinn = (2.0 + u_SpecularPower) * pow(max(0.0, dot(normal, halfDirection)), u_SpecularPower) / (8.0 * M_PI);
     
     vec4 diffuse = u_DirectionalLight.color * u_DirectionalLight.intensity * halfLambert;
     vec4 specular = u_DirectionalLight.color * u_DirectionalLight.intensity * blinn;
     */
    
    vec4 diffuse = vec4(0.0);
    vec4 specular = vec4(0.0);
    
    for (int i = 0; i < 2; i++) {
        vec3 lightDirection = u_PointLights[i].position - frag_Position;
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
    
    if (u_HasTexture) {
        diffuse *= texture2D(u_Texture, frag_TexCoord) * texture2D(u_Texture, frag_TexCoord);
    }
    
    gl_FragColor = diffuse * frag_Color + specular;
}

