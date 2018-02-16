#version 300 es

uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform lowp  vec4 u_Color;

in vec4 i_Position;

out lowp vec4 frag_Color;

void main(void) {
    frag_Color = u_Color;
    gl_Position = u_Projection * u_ModelView * i_Position;
}

