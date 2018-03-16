//
//  SlowTower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class SlowTower : Tower{
    
    override class var COST : Int {
        return 50
    }
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, color: Color) {
        super.init(x, z, shader: shader, color: color)
    }
    
    override func spawnProjectile(zombie: Minion) {
        let p = IceProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.xScale = 0.1
        p.yScale = 0.1
        p.zScale = 0.1
        p.speed = 4.0
        towerProjectiles.append(p)
    }
    
}
