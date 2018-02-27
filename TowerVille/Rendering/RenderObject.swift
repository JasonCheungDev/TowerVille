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
    var material : Material?
    var texture: GLuint = 0

    var currentModelView : GLKMatrix4 = GLKMatrix4()

    private var Shader : ShaderProgram!
    private var VertexDatas : [VertexData] = []
    private var Indices : [GLubyte] = []
    private var vao : GLuint = 0
    private var vertexBuffer : GLuint = 0
    private var indexBuffer : GLuint = 0
    
    
    init(fromShader shader: ShaderProgram, fromVertices vertices: [VertexData], fromIndices indices: [GLubyte])
    {
        self.Shader = shader
        self.VertexDatas = vertices
        self.Indices = indices
        
        self.SetupBuffers()
    }
    
    func modelMatrix() -> GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.gameObject!.x, self.gameObject!.y, self.gameObject!.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.gameObject!.xRot, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.gameObject!.yRot, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.gameObject!.zRot, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.gameObject!.xScale, self.gameObject!.yScale, self.gameObject!.zScale)
        return modelMatrix
    }
    
    // Draws the object as if it had no parent (Use for now until drawWithParent is implemented)
    func Draw() -> Void{
        
        if (gameObject == nil)
        {
            print("Error: Attempting to draw an unlinked RenderObject")
            return
        }
        
        //if let id = gameObject?.id {
        //    print("Drawing RO " + id)
        //}
        
        // Load custom presets
        material?.LoadMaterial()
        material?.LoadLightData(fromLights: LightManager.Instance.lights)
        
        // Load positional uniforms
        let mv = GLKMatrix4Multiply(Camera.ActiveCamera!.viewMatrix, self.modelMatrix())
        glUniformMatrix4fv(self.Shader.modelViewUniform, 1, GLboolean(GL_FALSE), mv.array)
        glUniformMatrix4fv(self.Shader.projectionUniform, 1, GLboolean(GL_FALSE), Camera.ActiveCamera!.projectionMatrix.array)

//        glActiveTexture(GLenum(GL_TEXTURE1))
//        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
//        print(self.texture)
//        glUniform1i(self.Shader.textureUniform, 1)
        
        // Load vertex data & draw
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(Indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
    }
    
    // Draws the object if it has a parent. (For root objects pass in just the ViewMatrix)
    func drawWithParentModelViewMatrix(_ parentModelViewMatrix: GLKMatrix4) {
        
        // Calculate new ModelView
        self.currentModelView = GLKMatrix4Multiply(parentModelViewMatrix, self.modelMatrix())
        
        // Load custom presets
        material?.LoadMaterial()
        
        // Load positional uniforms
        glUniformMatrix4fv(self.Shader.modelViewUniform, 1, GLboolean(GL_FALSE), self.currentModelView.array)
        glUniformMatrix4fv(self.Shader.projectionUniform, 1, GLboolean(GL_FALSE), Camera.ActiveCamera!.projectionMatrix.array)
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
        glUniform1i(self.Shader.textureUniform, 1)
        
        // Load vertex data & draw
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(Indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
    }

    private func SetupBuffers() {

        // Create a "profile" to switch to (allows switching multiple VBO's at once)
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)

        
        // Create buffers
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), VertexDatas.count * MemoryLayout<VertexData>.size, VertexDatas, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Indices.count * MemoryLayout<GLubyte>.size, Indices, GLenum(GL_STATIC_DRAW))
        
        
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
    
    func loadTexture(_ filename: String) {
        
        let path = Bundle.main.path(forResource: filename, ofType: nil)!
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            NSLog("ERROR: Failed to load texture %s", filename)
        }
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
        //        let ptr: UnsafeRawPointer? = nil
//        return ptr! + n * MemoryLayout<Void>.size
    }
}
