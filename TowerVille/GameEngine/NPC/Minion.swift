//
//  Minion.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Minion : VisualObject {
    
    var target : Structure? = nil
    
    private var _health : Int = 100
    var health : Int {
        get { return _health }
        set {
            if newValue <= 0
            {
                alive = false
                _health = 0
            }
            else
            {
                _health = newValue
            }
        }
    }
    var speed : Double = 2
    let shader : ShaderProgram
    var curIndex : Int = 1
    var wayPoints : [GameObject] = []
    var alive : Bool = true
    
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
        
        if (abs(wayPoints[curIndex].x - x) < 0.05 && abs(wayPoints[curIndex].z - z) < 0.05) {
            curIndex += 1
            if(curIndex == wayPoints.count) {
                let t = StateMachine.Instance.state() as! PlayState
                t.lives -= 1
                alive = false
                curIndex = 0
            }
        }
        
        let max_trans = Float(speed * dt)
        
        let x_trans = max(min(wayPoints[curIndex].x - x, max_trans), -max_trans)
        let z_trans = max(min(wayPoints[curIndex].z - z, max_trans), -max_trans)
        
        x += x_trans
        z += z_trans
       
    }
    
    
}
