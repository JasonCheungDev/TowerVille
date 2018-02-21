//
//  Camera.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-20.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Camera : GameObject
{
    static var ActiveCamera : Camera? = nil
    static var aspectRatio : CGFloat = 1

    var projectionMatrix : GLKMatrix4!
    var viewMatrix : GLKMatrix4!
    
    static func initialize(_ aspectRatio : CGFloat)
    {
        Camera.aspectRatio = aspectRatio
    }
}

// Please note x,y,z cannot be changed in this class
class OrthoCamPrefab : Camera {
    
    init (viewableTiles displaySize : Int)
    {
        super.init()
        
        var viewTar = GLKVector3Make(Float(displaySize - 2) / 2, 0, -Float(displaySize - 2) / 2)
        var viewPos = GLKVector3Add(viewTar, GLKVector3Make(Float(displaySize), Float(displaySize), Float(displaySize)))
        self.viewMatrix = GLKMatrix4MakeLookAt(
            viewPos.x, viewPos.y, viewPos.z, // camera position
            viewTar.x, viewTar.y, viewTar.z, // target position
            -1, 1, -1)                       // camera up vector
        
        var size : Float = Float(displaySize) * sqrt(2) // screen width in tiles
        var horSize = size / 2 / Float(Camera.aspectRatio)
        self.projectionMatrix = GLKMatrix4MakeOrtho(0.0, size, -horSize, horSize, 0, 100.0)
    }
}
