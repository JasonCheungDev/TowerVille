//
//  LaserTower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class LaserTower : Tower
{
    override class var NAME : String { return "Laser" }
    override class var ICON : String { return "LaserTower.png" }
    override class var HEALTH_LVLS : [Int] { return [50,100,150,250,500] }
    override class var COST_LVLS : [Int] { return [75,100,150,200,300] }

    var damage : Int = 100
    var shotWidth : Float = 1
    var fired : Bool = false
    
    private var laserLine : LineObject?

    
    override init (_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, color: Color)
    {
        super.init(x,z,shader: shader,color: color)

        self.maxRange = 4.0
        self.reloadTime = 5.0
        self.projectileLife = 1.0
    }
    
    override func SetupVisuals() {
        self.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_TOWER.rawValue)
        self.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_TWR_LASER.rawValue)
        self.setScale(0.5)
    }

    override func update(dt: TimeInterval) {
        super.update(dt: dt)
        
        // remove visuals after (1sec)
        if (fired && timeElapsed >= projectileLife)
        {
            laserLine = nil
        }
    }
    
    override func draw() {
        super.draw()
        laserLine?.draw()
    }
    
    override func spawnProjectile(zombie: Minion)
    {
        createLaser(target: zombie)     // show visuals
        damageEnemies(target: zombie)   // perform damage calculations
        fired = true
    }
    
    private func createLaser(target: Minion)
    {
        let towerPos = GLKVector2Make(self.x, self.z)
        var targetPos = GLKVector2Make(target.x, target.z)
        var shootDir = GLKVector2Subtract(targetPos, towerPos)
        shootDir = GLKVector2Normalize(shootDir)
        shootDir = GLKVector2MultiplyScalar(shootDir, self.maxRange)
        targetPos = GLKVector2Add(towerPos, shootDir)
        
        let mat = GenericMaterial(self.shader)
        mat.surfaceColor = Color(0,1,0,1)
        mat.specularPower = 0
        
        let line = LineObject(fromShader: self.shader, fromVectors:
            [GLKVector3Make(towerPos.x, 0.5, towerPos.y), GLKVector3Make(targetPos.x, 0.5, targetPos.y)])
        line.lineWidth = 20
        line.material = mat
        
        self.laserLine = line
    }
    
    private func damageEnemies(target: Minion)
    {
        let towerPos = GLKVector2Make(self.x, self.z)
        let targetPos = GLKVector2Make(target.x, target.z)
        
        let shootDir = GLKVector2Subtract(targetPos, towerPos)
        let normalDir = GLKVector2Make(-shootDir.y, shootDir.x)
        
        
        for m in PlayState.activeGame.minions
        {
            // first check in range
            if GameObject.distanceBetween2D(self, target) > maxRange
            {
                continue;
            }
            
            // check within line width
            let mPos = GLKVector2Make(m.x, m.z)
            let mDir = GLKVector2Subtract(mPos, towerPos)
            
            let proj = GLKVector2Project(mDir, normalDir)
            let dist = GLKVector2Length(proj)
            
            if dist <= shotWidth
            {
                m.health -= self.damage
            }
        }
    }
    
}
