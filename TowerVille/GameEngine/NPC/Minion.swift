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
    
    override init() {
        super.init()
        let shader = ShaderProgram(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(0,0,1,1)
        let ro = RenderObject(fromShader:shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        self.LinkRenderObject(ro)
        print("minion init")
        x = 0
        z = 0
    }
    
    override func update(dt: TimeInterval) {
        //go to target
        self.x += Float(speed * dt)
    }
    
    override func Draw() {
        super.Draw()
    }
    
    func updateTarget() {
        target = PlayState.map.Waypoints[curIndex]
    }
}
