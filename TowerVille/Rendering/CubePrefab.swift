//
//  CubePrefab.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-14.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class CubePrefab : VisualObject {
    
    init (_ shader : ShaderProgram)
    {
        super.init()
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(0,0,1,1)
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)

        self.renderObject = ro
        self.material = mat
    }
    
}
