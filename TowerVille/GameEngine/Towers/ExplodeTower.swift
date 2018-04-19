//
//  ExplodeTower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class ExplodeTower : Tower{
    override class var NAME : String { return "Explosion" }
    override class var ICON : String { return "ExplosionTower.png" }
    override class var HEALTH_LVLS : [Int] { return [100,150,300,500,1000] }
    override class var COST_LVLS : [Int] { return [50,100,200,400,600] }
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, color: Color) {
        super.init(x, z, shader: shader, color: color)
    }
    
    override func SetupVisuals() {
        self.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_TOWER.rawValue)
        self.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_TWR_EXPLODE.rawValue)
        self.setScale(0.5)
    }
    
    override func spawnProjectile(zombie: Minion) {
        let p = ExplodeProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setScale(scale: 0.3)
        p.speed = 4.0
        towerProjectiles.append(p)
    }
    
}
