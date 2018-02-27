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
    var structure : GameObject?
    
    func SetStructure(_ newStructure : GameObject) -> Bool {
        if self.structure != nil { return false }
        
        self.structure = newStructure
        newStructure.x = self.x
        newStructure.y = self.y + 0.01
        newStructure.z = self.z
        return true
    }
        
}
