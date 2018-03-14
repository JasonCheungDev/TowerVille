//
//  IceProjectile.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-10.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation


class IceProjectile : TowerProjectile
{
    override func MoveTowards(dt: Float) {
        
        distance = sqrt(pow(target.x-self.x, 2)+pow(target.z-self.z, 2))
        
        if(distance < 0.1){
            if(target.speed > 1.0){
                target.speed = target.speed / 2.0
            }
            
            return;
        }
        
        directionX = (target.x - self.x) / distance
        directionZ = (target.z - self.z) / distance
        
        self.x += directionX * speed * Float(dt)
        self.z += directionZ * speed * Float(dt)
    }
    
    
}
