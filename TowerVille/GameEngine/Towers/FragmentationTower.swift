//
//  FragmentationTower.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class FragmentationTower : Tower {
    
    override class var NAME : String { return "Fragmentation" }
    override class var ICON : String { return "watchtower.png" }
    override class var HEALTH_LVLS : [Int] { return [100,200,400,800,1600] }
    override class var COST_LVLS : [Int] { return [200,400,800,1600,3200] }
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, color: Color) {
        super.init(x,z,shader: shader,color: color)
        self.attacksPerSecond = 0.5
        self.projectileLife = 0.25
        self.reloadTime = 1 / self.attacksPerSecond
    }
    
    override func update(dt: TimeInterval) {
        
        if(timeElapsed > reloadTime){
            spawnFragment()
            timeElapsed = 0;
        }
        
        towerProjectiles = towerProjectiles.filter{$0.timeAlive <= projectileLife}
        
        if(towerProjectiles.count > 0){
            for p in towerProjectiles
            {
                p.update(dt: dt)
            }
        }
        
        timeElapsed += dt;
    }
    
    func spawnFragment(){
        
        let zombie = Minion(shader: shader)
        
        var p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.North)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.NorthEast)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.East)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.SouthEast)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.South)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.SouthWest)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.West)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        p = FragmentationProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setDirection(direction: Direction.NorthWest)
        p.setScale(scale: 0.15)
        p.speed = 4.0
        towerProjectiles.append(p)
        
        
    }
    
}
