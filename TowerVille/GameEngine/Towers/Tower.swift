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
    var attacksPerSecond : Double = 1.0
    
    var zombie : Minion!
    var towerProjectiles : [TowerProjectile] = []
    
    var timer = Timer()
    var shader : ShaderProgram!
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram) {
        super.init()
        self.x = x
        self.z = z
        self.shader = shader
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,0,1) // r g b a
        
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
        
        timer = Timer.scheduledTimer(timeInterval: 1 / attacksPerSecond, target: self, selector: #selector(self.scanForTargets), userInfo: nil, repeats: true)
        
    }
    
    func setMinion(min : Minion){
        zombie = min
    }
    
    @objc
    func scanForTargets(){
        //print("lookin for targets!")
        
        if zombie != nil
        {
            let p = TowerProjectile(self.x, self.z, shader: self.shader, target: zombie)
            towerProjectiles.append(p)
        }
        
        
    }

    override func update(dt: TimeInterval) {
        //go to target
        //self.z += Float(speed * dt)
        
    }
}
