//
//  Color.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

struct Color{
    
    var r : GLfloat = 0
    var g : GLfloat = 0
    var b : GLfloat = 0
    var a : GLfloat = 0
    
    init(_ r : GLfloat, _ g : GLfloat, _ b : GLfloat, _ a : GLfloat)
    {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}
