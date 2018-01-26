#version 300 es

// Input data
// Note: layout location # == # in glVertexAttribute
in vec4 vertexPosition_modelSpace;
in vec4 vertexColor;

// Values that stay constant for whole mesh
// uniform mat4 MVP;

// Forward color to fragment shader
out lowp vec4 fragmentColor;

void main()
{
    gl_Position = vertexPosition_modelSpace;
    
    fragmentColor = vec4(1,1,1,1);    // just pass color value to fragment shader
}
