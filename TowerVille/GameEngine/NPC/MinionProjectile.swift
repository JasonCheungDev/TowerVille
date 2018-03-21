//
//  MinionProjectile.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class MinionProjectile : VisualObject
{
    var target : Structure!
    var damage : Int = 10
    var alive : Bool = true
    var speed  : Float = 1.5
    
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, target : Structure)
    {
        super.init()
        self.x = x
        self.z = z
        self.xScale = 0.25
        self.yScale = 0.25
        self.zScale = 0.25
        self.target = target
        
        var objLoader = ObjLoader()
        objLoader.Read(fileName: "sphere")
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,0,0,1)
        let ro = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        // let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
        
    }
    
    override func update(dt: TimeInterval)
    {
        if (target != nil) {
            MoveTowards(dt: Float(dt))
        }
    }
    
    func MoveTowards(dt: Float)
    {
        let distance = GameObject.distanceBetween2D(self, target)
        
        if (distance < 0.25 && alive) {
            self.target.health -= damage;
            self.alive = false
            return;
        }
        
        let directionX = (target.x - self.x) / distance
        let directionZ = (target.z - self.z) / distance
        
        self.x += directionX * speed * Float(dt)
        self.z += directionZ * speed * Float(dt)
    }
    
}

