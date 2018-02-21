#version 300 es

uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform lowp  vec4 u_SurfaceColor;

in vec4 i_Position;
in vec2 i_TexCoord;
in vec3 i_Normal;

out lowp vec4 frag_Color;
out lowp vec2 frag_TexCoord;
out lowp vec3 frag_Normal;
out lowp vec3 frag_Position;
out lowp vec3 frag_Debug;

void main(void) {
    frag_Color = u_SurfaceColor;
    frag_TexCoord = i_TexCoord;
    frag_Normal = (u_ModelView * vec4(i_Normal, 0.0)).xyz;
    frag_Position = (u_ModelView * i_Position).xyz;
    frag_Debug = (u_ModelView * vec4(i_Normal, 0.0)).rgb;
    gl_Position = u_Projection * u_ModelView * i_Position;
}
