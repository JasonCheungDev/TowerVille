//
//  WaveController.swift
//  TowerVille
//
//  Created by Rian Neufelt on 2018-03-27.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class WaveController : GameObject {
    
    var spawners : [MinionSpawner] = []
    var curTime : TimeInterval = 0.0
    var spawnTime : TimeInterval = 5.0
    var currentWave : Int = 1
    let shader : ShaderProgram
    var finished : Bool = false
    var minionsLeft : Int = 0
    
    init(shader: ShaderProgram) {
        self.shader = shader
        
        spawners.append(MinionSpawner(minion: Minion(shader: shader), waypoints: WaveController.WAYPOINTS_LVL1))
        spawners[0].total = 1
        spawners.append(MinionSpawner(minion: RangeMinion(shader: shader), waypoints: WaveController.WAYPOINTS_LVL1))
        spawners[1].total = 1
        spawners[1].minion.speed = 1.5
        spawners[1].spawnTime = 2.5
        spawners.append(MinionSpawner(minion: HoppingMinion(shader: shader), waypoints: WaveController.WAYPOINTS_LVL1))
        spawners[2].spawnTime = 4
        spawners[2].total = 1
        
    }
    
    override func update(dt: TimeInterval) {
        if(finished) {
            curTime += dt
            if(curTime >= spawnTime) {
                finished = false
                curTime = 0.0
            }
            return
        }
        var currentAmount : Int = 0
        var currentTotal : Int = 0
        
        for spawner in spawners {
            currentAmount += spawner.current;
            currentTotal += spawner.total;
        }
        
        // minionsLeft = total minions - (currentSpawned - currentAlive)
        // .. = 40 - (10 - 10) = 40
        // .. = 40 - (20 - 15) = 35
        // .. = 40 - (40 - 10) = 30
        // math
        PlayState.activeGame.minionsLeft = currentTotal - (currentAmount - PlayState.activeGame.minions.count)
        
        if(currentAmount >= currentTotal && PlayState.activeGame.minions.isEmpty) {
            finishLevel()
        }
        for spawner in spawners {
            spawner.update(dt: dt)
        }
    }
    
    func finishLevel() {
        finished = true
        spawners[0].reset()
        spawners[0].total += 1
        
        spawners[1].reset()
        if(currentWave % 2 == 0) {
            spawners[1].total += 1
        }
        
        spawners[2].reset()
        if(currentWave % 5 == 0) {
            spawners[2].total += 1
        }
        
        if(currentWave % 10 == 0)
        {
            for spawner in spawners {
                spawner.minion.speed += 1
            }
        }
        
        if(currentWave % 3 == 0)
        {
            for spawner in spawners {
                spawner.minion.health += currentWave * 10
            }
        }
        
        currentWave += 1
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
