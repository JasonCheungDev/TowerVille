#version 300 es

// Values that stay constant for whole mesh
uniform highp mat4 mvp;
uniform vec4 color;
//uniform mat4 projection;
//uniform mat4 view;
//uniform mat4 model;

// Note: layout location # == # in glVertexAttribute
in vec4 vertexPosition_modelSpace;
in vec4 vertexColor;

// Forward color to fragment shader
out lowp vec4 fragmentColor;

void main()
{
    fragmentColor = color;    // just pass color value to fragment shader

    gl_Position = mvp *	vertexPosition_modelSpace;
    
}
