//
//  DirectionalLight.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-15.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class DirectionalLight : Light {
    
    var xDir : Float = 0
    var yDir : Float = 0
    var zDir : Float = 0
    var lightIntensity : Float = 1
    var lightColor : Color = Color(1,1,0,1)
    
}
