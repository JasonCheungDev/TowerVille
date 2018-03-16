//
//  SlowTower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class SlowTower : Tower{
    
    override func spawnProjectile(zombie: Minion) {
        let p = IceProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.xScale = 0.1
        p.yScale = 0.1
        p.zScale = 0.1
        towerProjectiles.append(p)
    }
    
}
