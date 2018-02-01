#version 300 es

// precision highp float; // change all float values to highp 
in lowp vec4 fragmentColor;  // must match "out" variable in vertex shader

out lowp vec4 color;

void main()
{
    color = fragmentColor;
}

/* Notes:
Fragment shader variables always require a precision qualifier. (Vertex shaders do not)
 - lowp, mediump, highp. (Use highp when in doubt)
 */
