//
//  ShaderProgram.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class ShaderProgram {
    var programHandle : GLuint = 0
    var mvpUniform : Int32 = 0
    var mUniform : Int32 = 0
    var vUniform : Int32 = 0
    var pUniform : Int32 = 0
    
    init(vertexShader: String, fragmentShader: String) {
        self.compile(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
    
    // call this function to begin using this objects vertex/fragment shader combo
    // note: sounds like switching between shaders has some overhead, careful how many times you do it!
    func prepareToDraw() {
        glUseProgram(self.programHandle)
    }
}

extension ShaderProgram {
    
    func ReadShaderFile(shaderFileName: String, shaderType:  GLenum) -> GLuint
    {
        let path = Bundle.main.path(forResource: shaderFileName, ofType: nil)
        
        do {
            // read file
            let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            var shaderStringLength : GLint = GLint(Int32(shaderString.length))
            var shaderCString = shaderString.utf8String
            
            // init shader
            let shaderHandle = glCreateShader(shaderType)
            glShaderSource(
                shaderHandle,
                GLsizei(1),
                &shaderCString,
                &shaderStringLength)
            
            // compile shader
            glCompileShader(shaderHandle)
            var compileStatus : GLint = 0
            glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
            
            // error checking
            if compileStatus == GL_FALSE {
                var infoLength : GLsizei = 0
                let bufferLength : GLsizei = 1024
                glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                var actualLength : GLsizei = 0
                
                glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
                NSLog("Shader file: \(shaderFileName) failed to compile.")
                NSLog(String(validatingUTF8: info)!)
                exit(1)
            }
            
            // return compiled shader
            return shaderHandle
            
        } catch {
            exit(1)
        }
    }
    
    func compile(vertexShader: String, fragmentShader: String) {
        
        // read/compile specified vertex and fragment shader from file
        let vertexShaderName = self.ReadShaderFile(shaderFileName: vertexShader, shaderType: GLenum(GL_VERTEX_SHADER))
        let fragmentShaderName = self.ReadShaderFile(shaderFileName: fragmentShader, shaderType: GLenum(GL_FRAGMENT_SHADER))
        
        // setup program and attach shaders
        self.programHandle = glCreateProgram()
        glAttachShader(self.programHandle, vertexShaderName)
        glAttachShader(self.programHandle, fragmentShaderName)
        
        // ensure the shader file follows this format!
        glBindAttribLocation(self.programHandle, VertexAttributes.position.rawValue, "vertexPosition");
        glBindAttribLocation(self.programHandle, VertexAttributes.normal.rawValue, "vertexNormal")
        
        // link program (doesn't actually use yet) (linking makes the table for variable lookup)
        glLinkProgram(self.programHandle)

        // get uniform variables (MUST BE AFTER LINKING)
        self.mvpUniform = glGetUniformLocation(self.programHandle, "mvp")
        self.mUniform = glGetUniformLocation(self.programHandle, "m")
        self.vUniform = glGetUniformLocation(self.programHandle, "v")
        self.pUniform = glGetUniformLocation(self.programHandle, "p")

        // error checking
        var linkStatus : GLint = 0
        glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            var infoLength : GLsizei = 0
            let bufferLength : GLsizei = 1024
            glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength : GLsizei = 0
            
            glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
            NSLog(String(validatingUTF8: info)!)
            exit(1)
        }
    }
}
