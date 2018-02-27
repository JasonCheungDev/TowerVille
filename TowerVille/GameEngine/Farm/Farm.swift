//
//  Farm.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation


class Farm : VisualObject, ResourceGenerator {
    
    static let COST : Int = 10
    
    var Health: Int = 100
    var ResourcePerSecond: Int = 2
    var Cost: Int = COST
    
    private let game : PlayState
    private var cooldown : Double = 1
    
    init(_ playState : PlayState, _ shader : ShaderProgram)
    {
        self.game = playState
        
        super.init()
        
        let mat = LambertMaterial(shader)
        mat.loadTexture("farm.png")
        mat.surfaceColor = Color(0, 0.2, 0, 1)
        
        let ro = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        ro.material = mat
        
        self.linkRenderObject(ro)        
    }
    
    func ProduceResource() -> Void {
        game.gold += ResourcePerSecond
    }
    
    override func update(dt: TimeInterval) {
        cooldown -= dt
        
        if (cooldown <= 0)
        {
            ProduceResource()
            cooldown = 1
        }
    }
}
