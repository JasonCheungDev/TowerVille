#version 300 es

precision mediump float;

uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform vec4 u_SurfaceColor;

in vec4 i_Position;
in vec2 i_TexCoord;
in vec3 i_Normal;

out vec4 frag_Color;
out vec2 frag_TexCoord;
out vec3 frag_Normal;
out vec3 frag_Position;

void main() {
    frag_Color = u_SurfaceColor;
    frag_TexCoord = i_TexCoord;
    frag_Normal = mat3(u_ModelView) * i_Normal;
    frag_Position = (u_ModelView * i_Position).xyz;
    gl_Position = u_Projection * u_ModelView * i_Position;
}
