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
    
    var target : Minion!
    var timeAlive : Double = 0
    
    var distance : Float = 0.0
    var directionX : Float = 0.0
    var directionZ : Float = 0.0
    var speed  : Float = 1.5
    
    
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, target : Minion) {
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
        
        timeAlive += dt
        
        if(target != nil){
            MoveTowards(dt: Float(dt))
        }
    }
    
    func MoveTowards(dt: Float){
        distance = sqrt(pow(target.x-self.x, 2)+pow(target.z-self.z, 2))
        
        if(distance < 0.1){
             return;
        }
        
        directionX = (target.x - self.x) / distance
        directionZ = (target.z - self.z) / distance
        
        self.x += directionX * speed * Float(dt)
        self.z += directionZ * speed * Float(dt)
        
    }
    
}

