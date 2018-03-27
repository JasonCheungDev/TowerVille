//
//  TowerProjectile.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class ExplodeProjectile : TowerProjectile{

    
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, target: Minion) {
        super.init(x, z, shader: shader, target: target)
        
        let mat = self.material as! LambertMaterial
        mat.surfaceColor = Color(1,0,0,1) // red explosion
        
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = ExplodeProjectile(self.x, self.z, shader: shader, target: self.target)
        return copy
    }
    
    
    override func MoveTowards(dt: Float) {
        
        distance = sqrt(pow(target.x-self.x, 2)+pow(target.z-self.z, 2))
        
        if(distance < 0.5 && isMoving){
            isMoving = false;
            
            for m in PlayState.activeGame.minions{
               
                let distBetweenMinionAndProjectile = sqrt(pow(m.x-self.x, 2)+pow(m.z-self.z, 2))
                
                if(distBetweenMinionAndProjectile < 10){ //aoe with distance of 5
                    m.health -= damage
                }
                
            }
            
            return;
        }
        
        if(isMoving){
            
            directionX = (target.x - self.x) / distance
            directionZ = (target.z - self.z) / distance
            directionY = (target.y - self.y) / distance
            
            self.x += directionX * speed * Float(dt)
            self.z += directionZ * speed * Float(dt)
            self.y += directionY * speed * Float(dt)
            
        }else{
            
            if(self.xScale > 2){
                
                timeAlive = 9999
                return;
            }
            
            self.xScale += 0.25
            self.setScale(scale: self.xScale)
        }
       
    }
    
}


