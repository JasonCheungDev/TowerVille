//
//  VisualObject.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class VisualObject : GameObject
{
    var renderObject : RenderObject?
    var material : Material?
    
    
    func draw()
    {
        // ensure VO is in a valid state before drawing
        if !checkValidState() { return }
        
        let activeShader = renderObject!.Shader!
        activeShader.prepareToDraw()

        // load material data
        material?.LoadMaterial()
        material?.LoadLightData(fromLights: LightManager.Instance.lights)
        
        // load positional data
        glBindVertexArrayOES(renderObject!.VAO)
        let mv = GLKMatrix4Multiply(Camera.ActiveCamera!.viewMatrix, renderObject!.modelMatrix(self))
        glUniformMatrix4fv(activeShader.modelViewUniform, 1, GLboolean(GL_FALSE), mv.array)
        glUniformMatrix4fv(activeShader.projectionUniform, 1, GLboolean(GL_FALSE), Camera.ActiveCamera!.projectionMatrix.array)
        
        // draw
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(renderObject!.indexCount), GLenum(GL_UNSIGNED_BYTE), nil)
    }
    
    func checkValidState() -> Bool
    {
        if renderObject == nil
        {
            return false
        }
        
        if material == nil
        {
            return false
        }
        
        if renderObject?.Shader !== material?.shader
        {
            NSLog("ERROR: VO shaders for RenderObject and Material do not match")
            return false
        }
        
        return true
    }
}
