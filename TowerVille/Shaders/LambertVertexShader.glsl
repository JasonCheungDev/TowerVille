#version 300 es

// object data (split up to handle eye direction)
uniform highp mat4 m;
uniform highp mat4 v;
uniform highp mat4 p;

// directional light
uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform vec4 surfaceColor;

in vec3 vertexPosition;     // model space
in vec3 vertexNormal;

out highp vec3 fragmentNormal;
out lowp vec4 fragmentColor;

void main()
{
    vec3 debugLightDirection = vec3(-1,-1,-1);
    
    vec3 normal = (v * m * vec4(vertexNormal, 0.0)).xyz;
    float diffuseFactor = max(-dot(normalize(normal), normalize(debugLightDirection)), 0.0);   // 0-1
    float halfLambertFactor = pow(diffuseFactor * 0.5 + 0.5, 2.0);
    
    // pass values to fragment shader
    fragmentNormal = normal;
    fragmentColor = surfaceColor * halfLambertFactor;
    gl_Position = p * v * m * vec4(vertexPosition,1);
}
