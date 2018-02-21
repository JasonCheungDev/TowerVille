//
//  LightManager.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-15.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class LightManager {
    
    static let Instance = LightManager()

    static let MAX_NUM_LIGHTS = 4
    
    var lights : [Light] = []
    
    private init()
    {
        
    }
    
}

