#version 300 es

// Input data
// Note: layout location # == # in glVertexAttribute
layout(location = 0) in vec3 vertexPosition_modelSpace;
layout(location = 1) in vec3 vertexColor;

// Values that stay constant for whole mesh
uniform mat4 MVP;

// Forward color to fragment shader
out vec4 fragmentColor;

void main()
{
    gl_Position = MVP * vec4(vertexPosition_modelSpace, 1);
    
    fragmentColor = vec4(1,1,1,1);    // just pass color value to fragment shader
}
