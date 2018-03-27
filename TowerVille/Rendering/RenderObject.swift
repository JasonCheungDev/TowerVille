//
//  RenderObject.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class RenderObject {

    var Shader : ShaderProgram!
    var VAO : GLuint = 0
    var indexCount : Int { get { return Indices.count } }
    var VertexDatas : [VertexData] = []
    var Indices : [GLushort] = []
    
    private var vertexBuffer : GLuint = 0
    private var indexBuffer : GLuint = 0
    
    
    init(fromShader shader: ShaderProgram, fromVertices vertices: [VertexData], fromIndices indices: [GLushort])
    {
        self.Shader = shader
        self.VertexDatas = vertices
        self.Indices = indices
        
        self.SetupBuffers()
    }
    
    func modelMatrix(_ gameObject : GameObject) -> GLKMatrix4
    {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, gameObject.x, gameObject.y, gameObject.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, gameObject.xRot, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, gameObject.yRot, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, gameObject.zRot, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, gameObject.xScale, gameObject.yScale, gameObject.zScale)
        return modelMatrix
    }
    
    private func SetupBuffers() {

        // Create a "profile" to switch to (allows switching multiple VBO's at once)
        glGenVertexArraysOES(1, &VAO)
        glBindVertexArrayOES(VAO)

        
        // Create buffers
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), VertexDatas.count * MemoryLayout<VertexData>.size, VertexDatas, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Indices.count * MemoryLayout<GLushort>.size, Indices, GLenum(GL_STATIC_DRAW))
        
        
        // Enable attributes (in)
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<VertexData>.size), BUFFER_OFFSET(0))
        
        // TODO REMOVE
        glEnableVertexAttribArray(VertexAttributes.color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<VertexData>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a :: offset is 3*sizeof(GLfloat)
        
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<VertexData>.size), BUFFER_OFFSET((3+4) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v :: offset is (3+4)*sizeof(GLfloat)
        
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<VertexData>.size), BUFFER_OFFSET((3+4+2) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v | nx, ny, nz :: offset is (3+4+2)*sizeof(GLfloat)
        
        
        // Finished - unbind
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
        //        let ptr: UnsafeRawPointer? = nil
//        return ptr! + n * MemoryLayout<Void>.size
    }
}
