#version 300 es

in vec3 fragmentColor;  // must match "out" variable in vertex shader

out vec3 color;

void main()
{
    color = fragmentColor;
}
