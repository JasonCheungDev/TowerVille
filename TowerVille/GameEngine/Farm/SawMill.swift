//
//  SawMill.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class SawMill : Farm {
    
    override class var NAME : String { return "Saw Mill" }
    override class var ICON : String { return "farm.png" }
    override class var HEALTH_LVLS : [Int] { return [50,80,110,140,200] }
    override class var COST_LVLS : [Int] { return [2,100,200,300,400] }

    
    override init(_ playState: PlayState, _ shader: ShaderProgram)
    {
        super.init(playState, shader)
        
        let objLoader = ObjLoader()
        objLoader.Read(fileName: "sawmill")
        
        let ro = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        
        let mat = LambertMaterial(shader)
        mat.surfaceColor = Color(133/255, 94/255, 66/255, 1)
        mat.specularPower = 1;

        self.renderObject = ro
        self.material = mat
        
        self.setScale(0.4)
        
        self.ResourcePerSecond = 2
    }
}
