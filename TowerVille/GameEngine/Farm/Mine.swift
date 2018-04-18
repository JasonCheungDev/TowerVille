//
//  Mine.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Mine : Farm {
    
    override class var NAME : String { return "Mine" }
    override class var ICON : String { return "farm.png" }
    override class var HEALTH_LVLS : [Int] { return [100,150,200,250,500] }
    override class var COST_LVLS : [Int] { return [3,400,600,800,1000] }
    
    
    override init(_ playState: PlayState, _ shader: ShaderProgram)
    {
        super.init(playState, shader)
        
        self.ResourcePerSecond = 4
    }
    
    override func SetupVisuals() {
        self.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_MINE.rawValue)
        self.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_MINE.rawValue)
        self.setScale(0.4)
    }
}
