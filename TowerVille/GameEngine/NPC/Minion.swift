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
        let mat = GenericMaterial(shader)
        mat.surfaceColor = Color(105/255,105/255,105/255,1)
        
        let objLoader = ObjLoader()
        objLoader.Read(fileName: "rat"); //octahedron
        
        let ro = RenderObject(fromShader:shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)

        self.renderObject = ro
        self.material = mat
        
        self.setScale(0.25)
        self.y = 0.2
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
        
        setRotation(xDelta: x_trans, zDelta: z_trans)
        
    }
    
    var rotationOffset : Float = 0
    func setRotation(xDelta: Float, zDelta:Float){ //x rot = vertical.
        if(zDelta < 0){
            yRot = (90 + rotationOffset) * .pi / 180//
        }
        if(zDelta > 0){
            yRot = (180 + rotationOffset) * .pi / 180
        }
        if(xDelta < 0){
            yRot = (-180 + rotationOffset) * .pi / 180
        }
        if(xDelta > 0){
            yRot = (0 + rotationOffset) * .pi / 180
        }
    }
    
    
    
}
