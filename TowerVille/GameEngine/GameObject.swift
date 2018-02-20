//
//  GameObject.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class GameObject {
    var id : String?
    var x: Float = 0
    var y : Float = 0
    var z : Float = 0
    var xRot : Float = 0
    var yRot : Float = 0
    var zRot : Float = 0
    
    func initialize(id_init : String?, x_init : Float, z_init : Float) {
        id = id_init
        x = x_init
        z = z_init
    }
    
    func update(dt : TimeInterval) {
        
    }
}

