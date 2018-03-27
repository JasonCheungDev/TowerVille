//
//  IceProjectile.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-10.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class IceProjectile : TowerProjectile
{
    
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, target: Minion) {
        super.init(x, z, shader: shader, target: target)
        
        let mat = self.material as! LambertMaterial
        mat.surfaceColor = Color(0,0,1,1) //blue
        
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = IceProjectile(self.x, self.z, shader: shader, target: self.target)
        return copy
    }
    
    override func MoveTowards(dt: Float) {
        
        distance = sqrt(pow(target.x-self.x, 2)+pow(target.z-self.z, 2)+pow(target.y-self.y, 2))
        
        if(distance < 0.1){
            if(target.speed > 1.0){
                target.speed = target.speed / 2.0
            }
            
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
