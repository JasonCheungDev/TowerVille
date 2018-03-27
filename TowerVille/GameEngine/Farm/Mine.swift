//
//  Mine.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Mine : Farm {
    
    override class var NAME : String { return "Mine" }
    override class var ICON : String { return "farm.png" }
    override class var HEALTH_LVLS : [Int] { return [100,150,200,250,500] }
    override class var COST_LVLS : [Int] { return [3,400,600,800,1000] }
    
    
    override init(_ playState: PlayState, _ shader: ShaderProgram)
    {
        super.init(playState, shader)
        
        let objLoader = ObjLoader()
        objLoader.Read(fileName: "mine")
        
        let ro = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        
        let mat = GenericMaterial(shader)
        mat.surfaceColor = Color(133/255, 94/255, 66/255, 1)
        mat.specularPower = 1;
        
        self.renderObject = ro
        self.material = mat
        
        self.setScale(0.5)
        
        self.ResourcePerSecond = 4
    }
}
