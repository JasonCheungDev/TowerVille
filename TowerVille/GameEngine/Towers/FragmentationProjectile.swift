//
//  FragmentationProjectile.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-10.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class FragmentationProjectile : VisualObject{
    
    var damage : Int = 10
    
    var timeAlive : Double = 0

    var speed  : Float = 1.5
    
    var direction : Direction = Direction.North
    
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, direction : Direction) {
        super.init()
        self.x = x
        self.z = z
        
        self.direction = direction
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,0,1)
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)

        self.renderObject = ro
        self.material = mat
    }
    
    override func update(dt: TimeInterval) {
        
        timeAlive += dt

        MoveTowards(dt: Float(dt))
    }
    
    func MoveTowards(dt: Float){
        
        switch(self.direction){
        case Direction.North:
                self.x += speed * Float(dt)
                //self.z += speed * Float(dt)
                break;
            
        default:
            break;
        }
    
    
    }
}

enum Direction {
    case North
    case NorthEast
    case East
    case SouthEast
    case South
    case SouthWest
    case West
    case NorthWest
}
