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
    
    var curIndex : Int = 0
    
    init(shader: ShaderProgram) {
        super.init()
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(0,0,1,1)
        let ro = RenderObject(fromShader:shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
        print("minion init")
        x = 0
        z = 0
    }
    
    override func update(dt: TimeInterval) {
        //go to target
        self.z += Float(speed * dt)
    }
    
    override func draw() {
        super.draw()
    }
    
    func updateTarget() {
        target = PlayState.map.Waypoints[curIndex]
    }
}
