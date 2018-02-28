//
//  Minion.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Minion : VisualObject {
    var target : GameObject? = nil
    
    var health : Int = 100
    var speed : Double = 2
    let shader : ShaderProgram
    var curIndex : Int = 1
    var wayPoints : [GameObject] = []
    
    init(shader: ShaderProgram) {
        self.shader = shader
        super.init()
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(0,0,1,1)
        let ro = RenderObject(fromShader:shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
        self.xScale = 0.4
        self.yScale = 0.3
        self.zScale = 0.4
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Minion(shader: shader)
        return copy
    }
    
    func setWayPoints(wayPoints : [GameObject]) {
        self.wayPoints = wayPoints
    }
    
    override func update(dt: TimeInterval) {
        
        if(wayPoints[curIndex].x - x < 0.1 && wayPoints[curIndex].z - z < 0.1) {
            curIndex += 1
            if(curIndex >= 5) {
                curIndex = 4
            }
            
        }
        if(wayPoints[curIndex].x > x) {
            x += Float(speed * dt)
        }
        else if(wayPoints[curIndex].x < x) {
            x += Float(-speed * dt)
        }
        if(wayPoints[curIndex].z > z) {
            z += Float(speed * dt)
        }
        else if(wayPoints[curIndex].z < z) {
            z += Float(-speed * dt)
        }
        
    }
}
