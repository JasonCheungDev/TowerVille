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
    
    class var WAYPOINTS_LVL1 : [GameObject]
    {
        let numberOfWaypoints = 7
        var waypoints : [GameObject] = []
        
        for _ in 0..<numberOfWaypoints
        {
            let go = GameObject()
            waypoints.append(go)
        }
        
        waypoints[0].x = 5
        waypoints[0].z = -5
        
        waypoints[1].x = 12
        waypoints[1].z = -5
        
        waypoints[2].x = 12
        waypoints[2].z = -8
        
        waypoints[3].x = 4
        waypoints[3].z = -8
        
        waypoints[4].x = 4
        waypoints[4].z = -11
        
        waypoints[5].x = 12
        waypoints[5].z = -11
        
        waypoints[6].x = 12
        waypoints[6].z = -16

        return waypoints
    }
    
}
