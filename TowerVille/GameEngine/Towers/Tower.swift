//
//  Tower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Tower : VisualObject{
    
    var health : Int = 100
    var maxRange : Float = 4.0
    var attacksPerSecond : Double = 1.0
    var projectileLife : Double = 8.0   //time before projectiles are destroyed, in seconds
    
    var zombie : Minion!
    var towerProjectiles : [TowerProjectile] = []
    
    var timer = Timer()
    var shader : ShaderProgram!
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram) {
        super.init()
        self.x = x
        self.z = z
        self.y = 0.4
        self.shader = shader
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(1,1,0,1) // r g b a
        
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        linkRenderObject(ro)
        
        timer = Timer.scheduledTimer(timeInterval: 1 / attacksPerSecond, target: self, selector: #selector(self.scanForTargets), userInfo: nil, repeats: true)
        
    }
    
    func spawnProjectile(zombie : Minion){
        
        //spawns a projectile
        let p = TowerProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.xScale = 0.1
        p.yScale = 0.1
        p.zScale = 0.1
        towerProjectiles.append(p)
        
    }
    
    @objc
    func scanForTargets(){
        //print("lookin for targets!")
        
        for z in PlayState.activeGame.minions
        {
            
            let distance = sqrt(pow(z.x-self.x, 2) + pow(z.z-self.z, 2))
            
            if(distance < maxRange){    //spawn projectile if within tower aggro range
                spawnProjectile(zombie: z)
            }
            
        }
        
    }
    
    
    override func draw(){
        super.draw()
      
        if(towerProjectiles.count > 0){
            for (index, projectile) in towerProjectiles.enumerated() {
                
                if(projectile.timeAlive > projectileLife){
                    towerProjectiles.remove(at: index)
                }else{
                    projectile.draw()
                }
            }
        }
       
        
    }

    override func update(dt: TimeInterval) {
        //go to target
        //self.z += Float(speed * dt)
        
        if(towerProjectiles.count > 0){ //put into tower.update
            for p in towerProjectiles
            {
                p.update(dt: dt)
            }
        }
        
    }
}
