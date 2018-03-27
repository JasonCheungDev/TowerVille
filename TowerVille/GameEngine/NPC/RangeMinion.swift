//
//  RangeMinion.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class RangeMinion : Minion
{
    var maxRange : Float = 4.0
    var activeProjectiles : [MinionProjectile] = []
    var reloadTime : Double = 2.0
    var reloadTimeElapsed : Double = 0.0
    
    override init(shader: ShaderProgram)
    {
        super.init(shader: shader)
        
        let mat = self.material as! LambertMaterial
        mat.surfaceColor = Color(1,0,0,1)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = RangeMinion(shader: shader)
        return copy
    }
    
    override func update(dt: TimeInterval) {
        super.update(dt: dt)
        
        // tower updates
        
        reloadTimeElapsed += dt
        
        if (target == nil)
        {
            scanForTargets()
        }
        
        if (target != nil && reloadTimeElapsed > reloadTime)
        {
            if (GameObject.distanceBetween2D(self, target!) < maxRange)
            {
                shootProjectile(target: self.target!)
            }
            else
            {
                target = nil
            }
        }
        
        
        // projectile updates
        
        if (activeProjectiles.count > 0) {
            for p in activeProjectiles
            {
                p.update(dt: dt)
            }
        }
        
        activeProjectiles = activeProjectiles.filter{ $0.alive }
    }
    
    override func draw() {
        super.draw()
        
        // projectile draws
        
        if (activeProjectiles.count > 0)
        {
            for p in activeProjectiles {
                p.draw()
            }
        }
    }
    
    func scanForTargets()
    {
        for t in PlayState.activeGame.towers {
            let distance = GameObject.distanceBetween2D(self, t)
            
            if (distance < maxRange) {
                target = t
                return
            }
        }
        
        for f in PlayState.activeGame.farms {
            let distance = GameObject.distanceBetween2D(self, f)
            
            if (distance < maxRange) {
                target = f
                return
            }
        }
    }
    
    func shootProjectile(target : Structure)
    {
        let p = MinionProjectile(self.x, self.z, shader: self.shader, target: target)
        activeProjectiles.append(p)
        reloadTimeElapsed = 0
    }
}
