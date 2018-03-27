//
//  FragmentationProjectile.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-10.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class FragmentationProjectile : TowerProjectile{
    var direction : Direction = Direction.North
    
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, target: Minion) {
        super.init(x, z, shader: shader, target: target)
        
        let mat = self.material as! GenericMaterial
        mat.surfaceColor = Color(0,1,0,1) //green
        
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = FragmentationProjectile(self.x, self.z, shader: shader, target: self.target)
        return copy
    }
    
    
    func setDirection(direction: Direction){
        self.direction = direction
    }
    
    override func MoveTowards(dt: Float){
        
        if(!isMoving){
            return
        }
        
        for m in PlayState.activeGame.minions{
            distance = sqrt(pow(m.x-self.x, 2)+pow(m.z-self.z, 2)+pow(m.y-self.y,2))
            
            if(distance < 0.5){
                
                isMoving = false;
                timeAlive = 9999;
                m.health -= damage
                return;
            }
        }
        
        switch(self.direction){
            
        case Direction.North:
            self.x -= speed * Float(dt)
            break
            
        case Direction.NorthEast:
            self.x -= speed * Float(dt)
            self.z -= speed * Float(dt)
            break
            
        case Direction.East:
            self.z -= speed * Float(dt)
            break
            
        case Direction.SouthEast:
            self.x += speed * Float(dt)
            self.z -= speed * Float(dt)
            break
            
        case Direction.South:
            self.x += speed * Float(dt)
            break
            
        case Direction.SouthWest:
            self.x += speed * Float(dt)
            self.z += speed * Float(dt)
            break;
            
        case Direction.West:
            self.z += speed * Float(dt)
            break
            
        case Direction.NorthWest:
            self.x -= speed * Float(dt)
            self.z += speed * Float(dt)
            break;
            
        default:
            break
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
