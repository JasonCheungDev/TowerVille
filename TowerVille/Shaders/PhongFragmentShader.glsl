uniform sampler2D u_Texture;

in lowp vec4 frag_Color;
in lowp vec2 frag_TexCoord;
in lowp vec3 frag_Normal;
in lowp vec3 frag_Position;

// Light isn't implemented yet 
struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
    highp float SpecularIntensity;
    highp float Shininess;
};
uniform Light u_Light;

out o_color;

void main(void) {

    // Ambient
    lowp vec3 AmbientColor = u_Light.Color * u_Light.AmbientIntensity;

    // Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec3 DiffuseColor = u_Light.Color * u_Light.DiffuseIntensity * DiffuseFactor;

    // Specular
    lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 Reflection = reflect(u_Light.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection, Eye)), u_Light.Shininess);
    lowp vec3 SpecularColor = u_Light.Color * u_Light.SpecularIntensity * SpecularFactor;

    o_color = texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);
}
