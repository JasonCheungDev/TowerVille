//
//  DebugData.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-14.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class DebugData {
    
    static let Instance = DebugData()
    
    static let cubeVertices : [VertexData] = [
        
        // Front
        VertexData( 1, -1, 1,  1, 0, 0, 1,  1, 0,  0, 0, 1), // 0
        VertexData( 1,  1, 1,  0, 1, 0, 1,  1, 1,  0, 0, 1), // 1
        VertexData(-1,  1, 1,  0, 0, 1, 1,  0, 1,  0, 0, 1), // 2
        VertexData(-1, -1, 1,  0, 0, 0, 1,  0, 0,  0, 0, 1), // 3
        
        // Back
        VertexData(-1, -1, -1, 0, 0, 1, 1,  1, 0,  0, 0,-1), // 4
        VertexData(-1,  1, -1, 0, 1, 0, 1,  1, 1,  0, 0,-1), // 5
        VertexData( 1,  1, -1, 1, 0, 0, 1,  0, 1,  0, 0,-1), // 6
        VertexData( 1, -1, -1, 0, 0, 0, 1,  0, 0,  0, 0,-1), // 7
        
        // Left
        VertexData(-1, -1,  1, 1, 0, 0, 1,  1, 0, -1, 0, 0), // 8
        VertexData(-1,  1,  1, 0, 1, 0, 1,  1, 1, -1, 0, 0), // 9
        VertexData(-1,  1, -1, 0, 0, 1, 1,  0, 1, -1, 0, 0), // 10
        VertexData(-1, -1, -1, 0, 0, 0, 1,  0, 0, -1, 0, 0), // 11
        
        // Right
        VertexData( 1, -1, -1, 1, 0, 0, 1,  1, 0,  1, 0, 0), // 12
        VertexData( 1,  1, -1, 0, 1, 0, 1,  1, 1,  1, 0, 0), // 13
        VertexData( 1,  1,  1, 0, 0, 1, 1,  0, 1,  1, 0, 0), // 14
        VertexData( 1, -1,  1, 0, 0, 0, 1,  0, 0,  1, 0, 0), // 15
        
        // Top
        VertexData( 1,  1,  1, 1, 0, 0, 1,  1, 0,  0, 1, 0), // 16
        VertexData( 1,  1, -1, 0, 1, 0, 1,  1, 1,  0, 1, 0), // 17
        VertexData(-1,  1, -1, 0, 0, 1, 1,  0, 1,  0, 1, 0), // 18
        VertexData(-1,  1,  1, 0, 0, 0, 1,  0, 0,  0, 1, 0), // 19
        
        // Bottom
        VertexData( 1, -1, -1, 1, 0, 0, 1,  1, 0,  0,-1, 0), // 20
        VertexData( 1, -1,  1, 0, 1, 0, 1,  1, 1,  0,-1, 0), // 21
        VertexData(-1, -1,  1, 0, 0, 1, 1,  0, 1,  0,-1, 0), // 22
        VertexData(-1, -1, -1, 0, 0, 0, 1,  0, 0,  0,-1, 0), // 23
        
    ]
    
    static let cubeIndices : [GLubyte] = [
        
        // Front
        0, 1, 2,
        2, 3, 0,
        
        // Back
        4, 5, 6,
        6, 7, 4,
        
        // Left
        8, 9, 10,
        10, 11, 8,
        
        // Right
        12, 13, 14,
        14, 15, 12,
        
        // Top
        16, 17, 18,
        18, 19, 16,
        
        // Bottom
        20, 21, 22,
        22, 23, 20
    ]
    
    static let rectVertices : [VertexData] = [
        
        // Front
        VertexData( 0.5, -1.5,  0.5,  1, 0, 0, 1,  1, 0,  0, 0, 1), // 0
        VertexData( 0.5,  1.5,  0.5,  0, 1, 0, 1,  1, 1,  0, 0, 1), // 1
        VertexData(-0.5,  1.5,  0.5,  0, 0, 1, 1,  0, 1,  0, 0, 1), // 2
        VertexData(-0.5, -1.5,  0.5,  0, 0, 0, 1,  0, 0,  0, 0, 1), // 3
        
        // Back
        VertexData(-0.5, -1.5, -0.5, 0, 0, 1, 1,  1, 0,  0, 0,-1), // 4
        VertexData(-0.5,  1.5, -0.5, 0, 1, 0, 1,  1, 1,  0, 0,-1), // 5
        VertexData( 0.5,  1.5, -0.5, 1, 0, 0, 1,  0, 1,  0, 0,-1), // 6
        VertexData( 0.5, -1.5, -0.5, 0, 0, 0, 1,  0, 0,  0, 0,-1), // 7
        
        // Left
        VertexData(-0.5, -1.5,  0.5, 1, 0, 0, 1,  1, 0, -1, 0, 0), // 8
        VertexData(-0.5,  1.5,  0.5, 0, 1, 0, 1,  1, 1, -1, 0, 0), // 9
        VertexData(-0.5,  1.5, -0.5, 0, 0, 1, 1,  0, 1, -1, 0, 0), // 10
        VertexData(-0.5, -1.5, -0.5, 0, 0, 0, 1,  0, 0, -1, 0, 0), // 11
        
        // Right
        VertexData( 0.5, -1.5, -0.5, 1, 0, 0, 1,  1, 0,  1, 0, 0), // 12
        VertexData( 0.5,  1.5, -0.5, 0, 1, 0, 1,  1, 1,  1, 0, 0), // 13
        VertexData( 0.5,  1.5,  0.5, 0, 0, 1, 1,  0, 1,  1, 0, 0), // 14
        VertexData( 0.5, -1.5,  0.5, 0, 0, 0, 1,  0, 0,  1, 0, 0), // 15
        
        // Top
        VertexData( 0.5,  1.5,  0.5, 1, 0, 0, 1,  1, 0,  0, 1, 0), // 16
        VertexData( 0.5,  1.5, -0.5, 0, 1, 0, 1,  1, 1,  0, 1, 0), // 17
        VertexData(-0.5,  1.5, -0.5, 0, 0, 1, 1,  0, 1,  0, 1, 0), // 18
        VertexData(-0.5,  1.5,  0.5, 0, 0, 0, 1,  0, 0,  0, 1, 0), // 19
        
        // Bottom
        VertexData( 0.5, -1.5, -0.5, 1, 0, 0, 1,  1, 0,  0,-1, 0), // 20
        VertexData( 0.5, -1.5,  0.5, 0, 1, 0, 1,  1, 1,  0,-1, 0), // 21
        VertexData(-0.5, -1.5,  0.5, 0, 0, 1, 1,  0, 1,  0,-1, 0), // 22
        VertexData(-0.5, -1.5, -0.5, 0, 0, 0, 1,  0, 0,  0,-1, 0), // 23
        
    ]

    var projectionMatrix : GLKMatrix4!
    var viewMatrix : GLKMatrix4!
    var modelMatrixCube : GLKMatrix4!   // debug transformation for the cube
    var aspectRatio : CGFloat
    var colorBuffer : GLuint = 0
    
    private init()
    {
        self.aspectRatio = 1.0
    }
    
    func initialize(_ aspectRatio : CGFloat)
    {
        var viewPos = GLKVector3Make(10, 10, 10)
        var viewTar = GLKVector3Make(0, 0, 0)
        viewMatrix = GLKMatrix4MakeLookAt(viewPos.x, viewPos.y, viewPos.z, // camera position
            viewTar.x, viewTar.y, viewTar.z, // target position
            -1, 1, -1) // camera up vector
        
        var size : Float = 10 * sqrt(2) // screen width in tiles
        projectionMatrix = GLKMatrix4MakeOrtho(0.0, size, -size / 2 / Float(aspectRatio), size / 2 / Float(aspectRatio), 0, 100.0)
    }

}

