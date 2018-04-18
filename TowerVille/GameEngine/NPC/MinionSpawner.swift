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
    var spawnTime : TimeInterval = 2.0
    let minion : Minion
    var total : Int = 10
    var current : Int = 0
    
    init(minion : Minion, waypoints : [GameObject]) {
        self.minion = minion
        self.wayPoints = waypoints
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
    
    func reset() {
        current = 0
        curTime = 0
    }
    
}
