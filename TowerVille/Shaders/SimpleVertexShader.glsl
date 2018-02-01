#version 300 es

// Values that stay constant for whole mesh
uniform highp mat4 mvp;
//uniform mat4 projection;
//uniform mat4 view;
//uniform mat4 model;

// Input data
// Note: layout location # == # in glVertexAttribute
in vec4 vertexPosition_modelSpace;
in vec4 vertexColor;



// Forward color to fragment shader
out lowp vec4 fragmentColor;

void main()
{
    fragmentColor = vertexColor;    // just pass color value to fragment shader

    gl_Position = mvp *	vertexPosition_modelSpace;
    
}
