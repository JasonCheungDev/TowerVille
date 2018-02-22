#version 300 es

precision mediump float;

uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform lowp vec4 u_SurfaceColor;

in vec4 i_Position;
in vec2 i_TexCoord;
in vec3 i_Normal;

out lowp vec4 frag_Color;
out vec2 frag_TexCoord;
out vec3 frag_Normal;
out vec3 frag_Position;

void main(void) {
    //TODO : remove
    float desaturationCoef = 0.333;
    float averageLuminance = dot(u_SurfaceColor.rgb, vec3(0.333));
    
    frag_Color.rgb = mix(u_SurfaceColor.rgb, vec3(averageLuminance), desaturationCoef);
    frag_TexCoord = i_TexCoord;
    frag_Normal = (u_ModelView * vec4(i_Normal, 0.0)).xyz;
    frag_Position = (u_ModelView * i_Position).xyz;
    gl_Position = u_Projection * u_ModelView * i_Position;
}
