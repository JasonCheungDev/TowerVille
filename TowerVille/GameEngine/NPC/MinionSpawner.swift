//
//  MinionSpawner.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class MinionSpawner : GameObject {
    
    var wayPoints : [GameObject] = []
    var curTime : TimeInterval = 0.0
    let spawnTime : TimeInterval = 2.0
    let minion : Minion
    let total : Int = 10
    var current : Int = 0
    
    init(minion : Minion) {
        self.minion = minion
        
        for _ in 0...5 {
            let go = GameObject()
            wayPoints.append(go)
        }
        
        wayPoints[0].x = 4.0
        wayPoints[0].z = -5.0
        
        wayPoints[1].x = 10.0
        wayPoints[1].z = -5.0
        
        wayPoints[2].x = 10.0
        wayPoints[2].z = -5.0
        
        wayPoints[3].x = 10.0
        wayPoints[3].z = 0.0
        
        wayPoints[4].x = 10.0
        wayPoints[4].z = -5.0
        
        wayPoints[5].x = 10.0
        wayPoints[5].z = -5.0
        
    }
    
    func spawn(minions: inout [Minion]) {
        let c = minion.copy() as! Minion
        c.setWayPoints(wayPoints: wayPoints)
        c.x = wayPoints[0].x
        c.z = wayPoints[0].z
        minions.append(c)
        current += 1
    }
    
    func update(dt: TimeInterval, minions: inout [Minion]) {
        curTime += dt
        if(current <= total && curTime >= spawnTime) {
            curTime = 0.0
            spawn(minions: &minions)
        }
    }
    
}
