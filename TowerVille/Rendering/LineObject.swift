//
//  LineObject.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//
//  Sample Usage:
//  var lineObj = LineObject(fromShader: self.shader, fromVectors: [GLKVector3Make(0,0,0), GLKVector3Make(5,0,-5), GLKVector3Make(7,0,-12)])
//  var mat = LambertMaterial(self.shader)
//  mat.surfaceColor = Color(1,0,0,1)
//  lineObj.material = mat
//

import Foundation
import GLKit

class LineObject : VisualObject
{
    var lineWidth : Float = 10
    var vertexData : [VertexData] = []
    var indices : [GLubyte] = []
    
    init(fromShader shader : ShaderProgram, fromVectors vectors : [GLKVector3])
    {
        super.init()
        
        // generate data based off points
        for i in 0..<vectors.count
        {
            let v = VertexData(vectors[i].x, vectors[i].y, vectors[i].z)
            vertexData.append(v)
            
            if i == 0 { continue }
            indices.append(GLubyte(i-1))
            indices.append(GLubyte(i))
        }
        
        // assign self generated RO
        let ro = RenderObject(fromShader: shader, fromVertices: vertexData, fromIndices: indices)
        self.renderObject = ro
    }
    
    init(fromShader shader : ShaderProgram, fromPoints points : [GameObject])
    {
        super.init()
        
        // generate data based off points
        for i in 0..<points.count
        {
            let v = VertexData(points[i].x, points[i].y, points[i].z)
            vertexData.append(v)
            
            if i == 0 { continue }
            indices.append(GLubyte(i-1))
            indices.append(GLubyte(i))
        }
        
        // assign self generated RO
        let ro = RenderObject(fromShader: shader, fromVertices: vertexData, fromIndices: indices)
        self.renderObject = ro
    }
    
    override func draw()
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
        let mv = GLKMatrix4Multiply(Camera.ActiveCamera!.viewMatrix, GLKMatrix4Identity)
        glUniformMatrix4fv(activeShader.modelViewUniform, 1, GLboolean(GL_FALSE), mv.array)
        glUniformMatrix4fv(activeShader.projectionUniform, 1, GLboolean(GL_FALSE), Camera.ActiveCamera!.projectionMatrix.array)
        
        // draw (LINES)
        glLineWidth(lineWidth)
        glDrawElements(GLenum(GL_LINES), GLsizei(renderObject!.indexCount), GLenum(GL_UNSIGNED_BYTE), nil)

    }
}
