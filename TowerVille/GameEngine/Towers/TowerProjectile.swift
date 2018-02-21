//
//  TowerProjectile.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-02-20.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class TowerProjectile : VisualObject{
    var damage : Int = 10
    var speed  : GLfloat = 1.5
    
    var target : GameObject!
    
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, target : GameObject) {
        super.init()
        self.x = x
        self.z = z
        
        self.target = target
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,0,1)
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
    }
    
    override func update(dt: TimeInterval) {
        //go to target, implement a MoveTowards func
        self.x -= 0.50
        self.z -= 0.50
        
    }
    
    func MoveTowards(){
        
    }
    
}

