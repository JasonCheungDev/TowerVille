//
//  Tower.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Tower : Structure {
    
    override class var NAME : String { return "Shooter" }
    override class var ICON : String { return "watchtower.png" }
    override class var HEALTH_LVLS : [Int] { return [100,150,300,500,1000] }
    override class var COST_LVLS : [Int] { return [25,50,100,200,400] }

    var maxRange : Float = 5.0
    var attacksPerSecond : Double = 1.0
    var projectileLife : Double = 4.0   //time before projectiles are destroyed, in seconds
    
    var zombie : Minion!
    var towerProjectiles : [TowerProjectile] = []
    
    var timer = Timer()
    var shader : ShaderProgram!
    
    private var target : Minion!
    
    var timeElapsed : Double = 0.0  //time elapsed between each attack - attacks are initiated by targeting zombies with "scanForTargets()" method
    var reloadTime : Double!        //dynamically calculated based on attacks per second. If attackspeed (attacks per second) is 2, then reload time is 0.5 (1 second / 2.0 attacks a second)
    
    init(_ x : GLfloat, _ z : GLfloat, shader : ShaderProgram, color: Color) {
        super.init()
        self.x = x
        self.z = z
        self.y = 0.0
        self.xScale = 0.5
        self.yScale = 0.5
        self.zScale = 0.5
        self.shader = shader
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = color    //Color(1,1,0,1) // r g b a
        
        let goat = ObjLoader()
        goat.smoothed = true
        goat.Read(fileName: "rook")
        
        let ro = RenderObject(fromShader: shader, fromVertices: goat.vertexDataArray, fromIndices: goat.indexDataArray)
 
        self.renderObject = ro
        self.material = mat
        
        //timer = Timer.scheduledTimer(timeInterval: 1 / attacksPerSecond, target: self, selector: #selector(self.scanForTargets), userInfo: nil, repeats: true)
        reloadTime = 1.0 / attacksPerSecond;    //calculates how long the tower will wait before scanning and shooting a projectile at zombie
    }
    
    func spawnProjectile(zombie : Minion){
        //spawns a projectile
        let p = TowerProjectile(self.x, self.z, shader: self.shader, target: zombie)
        p.setScale(scale: 0.15)
        towerProjectiles.append(p)
    }
    
    func scanForTargets(){
        //print("lookin for targets!")
        for z in PlayState.activeGame.minions
        {
            
            let distance = sqrt(pow(z.x-self.x, 2) + pow(z.z-self.z, 2))
            
            if(distance < maxRange){    //spawn projectile if within tower aggro range
                spawnProjectile(zombie: z)
                return  //shoots only 1 projectile, not aoe
            }
            
        }
        
    }
    
    
    override func draw(){
        super.draw()
      
        if(towerProjectiles.count > 0){
            /*for (_, projectile) in towerProjectiles.enumerated() {
                    projectile.draw()
            }*/ 
            for p in towerProjectiles{
                p.draw()
            }
            
        }
        
    }

    //scan for targets, then update the positions of each projectiles spawned by this tower.
    override func update(dt: TimeInterval) {
        //go to target
        
        if(timeElapsed > reloadTime){
            scanForTargets();
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
}
