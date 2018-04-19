//
//  Light.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-15.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Light : GameObject
{
    override init()
    {
        super.init()
        LightManager.Instance.lights.append(self)
    }
}
