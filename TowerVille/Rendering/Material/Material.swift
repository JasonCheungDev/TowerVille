//
//  Material.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

protocol Material {
    
    var shader : ShaderProgram { get }
    
    func LoadMaterial() -> Void
    
    func LoadLightData(fromLights lights : [Light])
    
}
