//
//  Tower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Tower : VisualObject{
    var health : Int = 100
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram) {
        super.init()
        self.x = x
        self.z = z
        
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,0,1)
        
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        
        //let vo = VisualObject()
        LinkRenderObject(ro)
        //self.debugVisualObjects.append(vo)
    }
    
    
    

}
