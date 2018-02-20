#version 300 es

in lowp vec4 frag_Color;

out lowp vec4 o_color;

void main()
{
    o_color = frag_Color;
}

/* Notes:
Fragment shader variables always require a precision qualifier. (Vertex shaders do not)
 - lowp, mediump, highp. (Use highp when in doubt)
 */
