//
//  Vertex.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

struct Vertex{
    var x : GLfloat = 0.0
    var y : GLfloat = 0.0
    var z : GLfloat = 0.0
 
    init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat)
    {
        self.x = x;
        self.y = y;
        self.z = z;
    }
}
