//
//  SawMill.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class SawMill : Farm {
    
    override class var NAME : String { return "Saw Mill" }
    override class var ICON : String { return "farm.png" }
    override class var HEALTH_LVLS : [Int] { return [50,80,110,140,200] }
    override class var COST_LVLS : [Int] { return [2,100,200,300,400] }

    
    override init(_ playState: PlayState, _ shader: ShaderProgram)
    {
        super.init(playState, shader)
        
        self.ResourcePerSecond = 2
    }
}
