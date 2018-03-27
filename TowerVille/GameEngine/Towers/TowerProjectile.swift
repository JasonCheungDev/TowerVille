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
    var directionY : Float = 0.0
    var speed  : Float = 5
    var isMoving : Bool = true
    let shader : ShaderProgram
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, target : Minion) {
        self.shader = shader
        super.init()
        self.x = x
        self.z = z
        self.target = target
        
        let objLoader = ObjLoader()
        objLoader.smoothed = true
        objLoader.Read(fileName: "icosahedron")
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,1,1)
        let ro = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)

        self.renderObject = ro
        self.material = mat
    }
    
    func setScale(scale: Float){
        self.xScale = scale;
        self.yScale = scale;
        self.zScale = scale;
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TowerProjectile(self.x, self.z, shader: shader, target: self.target)
        return copy
    }
    
    override func update(dt: TimeInterval) {
        
        timeAlive += dt
        
        if(target != nil){
            MoveTowards(dt: Float(dt))
        }
    }
    
    func MoveTowards(dt: Float){
        distance = sqrt(pow(target.x-self.x, 2)+pow(target.z-self.z, 2)+pow(target.y-self.y, 2))
        
        if(distance < 0.5 && timeAlive < 1000){
            target.health -= damage;
            timeAlive = 9999; //sets time alive to a large value in order to stop projectione animation.
            return;
        }
        
        directionX = (target.x - self.x) / distance
        directionZ = (target.z - self.z) / distance
        directionY = (target.y - self.y) / distance
        
        self.x += directionX * speed * Float(dt)
        self.z += directionZ * speed * Float(dt)
        self.y += directionY * speed * Float(dt)
        
    }
    

}

