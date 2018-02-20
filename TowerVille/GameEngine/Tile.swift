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
        VertexData( 0.4, 0, -0.4, 1, 0, 0, 1,  1, 0,  0, 1, 0),
        VertexData( 0.4, 0, 0.4, 0, 1, 0, 1,  1, 1,  0, 1, 0),
        VertexData( -0.4, 0, 0.4, 0, 0, 1, 1,  0, 1,  0, 1, 0),
        VertexData( -0.4, 0, -0.4, 0, 0, 0, 1,  0, 0,  0, 1, 0),
    ]

    // Note: Order matters
    static let indexData : [GLubyte] = [
        2,1,0,
        0,3,2
    ]
    
    var xCoord : uint = 0
    var yCoord : uint = 0
        
}
