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
        
        // auto place some waypoints
        // TODO : remove
        let numberOfWaypoints = 7
        for _ in 0..<numberOfWaypoints {
            let go = GameObject()
            wayPoints.append(go)
        }
        
        wayPoints[0].x = 5
        wayPoints[0].z = -5
        
        wayPoints[1].x = 12
        wayPoints[1].z = -5
        
        wayPoints[2].x = 12
        wayPoints[2].z = -8
        
        wayPoints[3].x = 4
        wayPoints[3].z = -8
        
        wayPoints[4].x = 4
        wayPoints[4].z = -11
        
        wayPoints[5].x = 12
        wayPoints[5].z = -11
        
        wayPoints[6].x = 12
        wayPoints[6].z = -16
        
    }
    
    func spawn() {
        let c = minion.copy() as! Minion
        c.setWayPoints(wayPoints: wayPoints)
        c.x = wayPoints[0].x
        c.z = wayPoints[0].z
        let t = StateMachine.Instance.state() as! PlayState
        t.minions.append(c)
        current += 1
    }
    
    override func update(dt: TimeInterval) {
        curTime += dt
        
        let t = StateMachine.Instance.state() as! PlayState
        if let i = t.minions.index(where: { !$0.alive }) {
            t.minions.remove(at: i)
        }
        if(current <= total && curTime >= spawnTime) {
            curTime = 0.0
            spawn()
        }
    }
    
}
