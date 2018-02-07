//
//  Tile.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Tile : VisualObject {
    
    static let vertexData = [
        Vertex(0.45,  0, 0.45),
        Vertex(0.45,  0, -0.45),
        Vertex(-0.45, 0, 0.45),
        Vertex(-0.45, 0, -0.45)
    ]
    
    static let indexData : [GLubyte] = [
        0,1,2,
        1,2,3
    ]
    
    var xCoord : uint = 0
    var yCoord : uint = 0
        
}
