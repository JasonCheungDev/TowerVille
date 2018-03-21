precision mediump float;

// uniforms
uniform highp mat4 u_ModelView;
uniform highp mat4 u_Projection;
uniform lowp vec4 u_SurfaceColor;

// attributes
attribute vec4 i_Position;
attribute vec2 i_TexCoord;
attribute vec3 i_Normal;

// varying
varying lowp vec4 frag_Color;
varying vec2 frag_TexCoord;
varying vec3 frag_Normal;varying vec3 frag_Position;

void main(void) {
    //TODO : remove
    float desaturationCoef = 0.5;
    vec3 linearSurfaceColor = pow(u_SurfaceColor.rgb, vec3(2.2/1.0));
    float averageLuminance = dot(linearSurfaceColor, vec3(0.333));
    
    frag_Color.rgb = mix(linearSurfaceColor, vec3(averageLuminance), desaturationCoef);
    frag_TexCoord = i_TexCoord;
    frag_Normal = normalize((u_ModelView * vec4(i_Normal, 0.0)).xyz);
    frag_Position = (u_ModelView * i_Position).xyz;
    gl_Position = u_Projection * u_ModelView * i_Position;
}
