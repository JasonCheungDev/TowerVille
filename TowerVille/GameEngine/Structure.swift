//
//  Structure.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-20.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Structure : VisualObject
{
    class var NAME : String { return "Structure" }
    class var ICON : String { return "wip.jpg" }
    class var COST : Int { return COST_LVLS[0] }
    class var HEALTH_LVLS : [Int] { return [100,125,150,200,500] }
    class var COST_LVLS   : [Int] { return [10,25,50,100,200] }

    var maxHealth : Int {
        get { return Structure.HEALTH_LVLS[level-1] }
    }
    var upgradeCost : Int {
        get {
            if level == 5 { return -1 }
            else { return Structure.COST_LVLS[level] }
        }
    }
    
    var health : Int = Structure.HEALTH_LVLS[0]
    var level  : Int = 1
    
    
    // should this be a readonly property? hmm....
    func getRepairCost() -> Int
    {
        let dmgPercent = 1.0 - (Float(health) / Float(maxHealth))
        let repairCost = Float(Structure.COST_LVLS[level-1]) * dmgPercent
        return Int(repairCost.rounded(.up))
    }
    
    func getSellCost() -> Int
    {
        var sum = 0
        for i in 0..<level { sum += Structure.COST_LVLS[i] }
        return sum / 2
    }
    
    func upgrade()
    {
        level += 1
        health = maxHealth
    }
}
