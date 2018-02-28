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
    let total : Int = 1
    var current : Int = 0
    
    init(minion : Minion) {
        self.minion = minion
        
        // auto place some waypoints
        // TODO : remove
        var numberOfWaypoints = 16
        for i in 0..<numberOfWaypoints {
            let go = GameObject()
            wayPoints.append(go)
        }
        var x_temp = 0
        var z_temp = -5
        for i in 0..<(numberOfWaypoints/2) {
            wayPoints[2 * i].x = Float(8 * x_temp + 5)
            wayPoints[2 * i].z = Float(z_temp)
            x_temp = (x_temp + 1) % 2
            wayPoints[2 * i + 1].x = Float(8 * x_temp + 5)
            wayPoints[2 * i + 1].z = Float(z_temp)
            z_temp = z_temp - 1
        }
        
        
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
