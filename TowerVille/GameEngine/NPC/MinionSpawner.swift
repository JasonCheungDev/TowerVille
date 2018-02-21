//
//  MinionSpawner.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class MinionSpawner : GameObject {
    
    let wayPoints : [GameObject]
    var curTime : TimeInterval = 0.0
    let spawnTime : TimeInterval = 2.0
    let minion : Minion
    var minions : [Minion] = []
    let total : Int = 10
    var current : Int = 0
    
    init(wayPoints : [GameObject], minion : Minion) {
        self.wayPoints = wayPoints
        self.minion = minion
    }
    
    func spawn() {
        let c = minion.copy()
        //minions.append()
    }
    
    override func update(dt: TimeInterval) {
        curTime += dt
        if(current <= total && curTime >= spawnTime) {
            curTime = 0.0
            spawn()
        }
    }
    
}
