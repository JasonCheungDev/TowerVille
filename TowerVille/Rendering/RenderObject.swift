//
//  RenderObject.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class RenderObject{
    
    var gameObject : VisualObject?
    
    var Shader : ShaderProgram!
    var Material : Material?
    var Vertices : [Vertex] = []
    var Indices : [GLubyte] = []
    
    var vertexBuffer : GLuint = 0
    var indexBuffer : GLuint = 0
    
    func Draw() -> Void{
        
        if (gameObject == nil)
        {
            print("Error: Attempting to draw an unlinked RenderObject")
            return
        }
        
        if let id = gameObject?.ID {
            print("Drawing RO " + id)
        }
        
        // Load custom presets
        Material?.LoadMaterial()
        
        var modelMatrix = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.gameObject!.x, self.gameObject!.y, self.gameObject!.z)
        // TODO: Replace DebugData with GameManager.Instance?
        var mvp = GLKMatrix4Multiply(DebugData.Instance.projectionMatrix, DebugData.Instance.viewMatrix)
        mvp = GLKMatrix4Multiply(mvp, modelMatrix)
        glUniformMatrix4fv(self.Shader.mvpUniform, 1, GLboolean(GL_FALSE), mvp.array)
        
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), nil) // or BUFFER_OFFSET(0)
                
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(DebugData.indices.count), GLenum(GL_UNSIGNED_BYTE), nil)

        glDisableVertexAttribArray(VertexAttributes.position.rawValue)
    }
    
    init(fromShader shader: ShaderProgram, fromVertices vertices: [Vertex], fromIndices indices: [GLubyte])
    {
        self.Shader = shader
        self.Vertices = vertices
        self.Indices = indices
        
        self.SetupBuffers()
        
        print(vertices)
        print(indices)
    }
    
    private func SetupBuffers() {

        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let count = DebugData.cubePositionData.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, DebugData.cubePositionData, GLenum(GL_STATIC_DRAW))

        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), DebugData.indices.count * MemoryLayout<GLubyte>.size, DebugData.indices, GLenum(GL_STATIC_DRAW))

    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
        let ptr: UnsafeRawPointer? = nil
        return ptr! + n * MemoryLayout<Void>.size
    }
}
