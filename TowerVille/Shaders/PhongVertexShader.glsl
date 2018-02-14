#version 300 es

// object data (split up to handle eye direction)
uniform highp mat4 m;
uniform highp mat4 v;
uniform highp mat4 p;

// directional light
uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform vec4 diffuseColor;          // nay
uniform float diffuseIntensity;
uniform vec4 ambientColor;          // yay
uniform vec4 specularColor;         // nay
uniform float specularIntensity;
uniform float specularShininess;

// TODO: need to mix material color (tint) w/ texture later

in vec3 vertexPosition;     // model space
in vec3 vertexNormal;

out highp vec3 fragmentNormal;
out lowp vec4 fragmentColor;

void main()
{
    // Ambient
//    vec3 aColor = lightColor * ambientColor;
    
    // Difuse

    vec3 normal = (v * m * vec4(vertexNormal, 0.0)).xyz;

    // vec3 normal = normalize(vertexNormal * mvp);
    float diffuseFactor = max(-dot(normal, lightDirection), 0.0);   // 0-1
    // fragmentColor = vec4(1,0,0,0) * diffuseFactor;
    fragmentNormal = normal;
    fragmentColor = vec4(normal, 1);

    // Specular
    // vec3 eye = normalize(v * m * vertexPosition)
    
    // find light strength
    gl_Position = p * v * m * vec4(vertexPosition,1);
}
