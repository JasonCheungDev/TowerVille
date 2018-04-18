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
    override class var ICON : String { return "Sawmill.png" }
    override class var HEALTH_LVLS : [Int] { return [20,40,60,80,100] }
    override class var COST_LVLS : [Int] { return [50,100,200,300,400] }

    
    override init(_ playState: PlayState, _ shader: ShaderProgram)
    {
        super.init(playState, shader)
        
        self.ResourcePerSecond = 2
    }
    
    override func SetupVisuals() {
        self.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_SAWMILL.rawValue)
        self.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_SAWMILL.rawValue)
        setScale(0.4)

    }
}
