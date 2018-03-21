//
//  FragmentationTower.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-21.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class FragmentationTower : Tower {
    
    override class var NAME : String { return "Slow" }
    override class var ICON : String { return "slow_tower.png" }
    override class var HEALTH_LVLS : [Int] { return [100,250,350,450,2000] }
    override class var COST_LVLS : [Int] { return [80,120,250,400,600] }
    
    
    
    
    
}
