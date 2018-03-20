//
//  Farm.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import Darwin
import GLKit


class Farm : VisualObject, ResourceGenerator {
    
    static let COST : Int = 10
    
    var Health: Int = 100
    var ResourcePerSecond: Int = 1
    var ResourceMultiplier: Int = 1
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
    
    func SetValue(x: Float, y: Float){
        self.x = x
        self.y = y
        
        //Calculate how close the farm is to the nearest path, and increase value accordingly
        var minDist = INT_MAX
        let map = PlayState.activeGame.map
        
        for x in 0 ..< map.Tiles.count {
            for y in 0 ..< map.Tiles[x].count {
                
                if(map.Tiles[x][y].type == TileType.Path){
                    let distance = sqrt(pow(Float(
                        map.Tiles[x][y].x) - self.x, 2) + pow( Float(map.Tiles[x][y].z) - self.y, 2))
                    if(distance < Float(minDist)){
                        minDist = Int32(distance)
                    }
                    
                    //print("The distance is ", minDist)
                }
            }
        }
        
        //set value based on how close the farm is to the nearest path
        switch(minDist){
        case 1:
            ResourcePerSecond = ResourceMultiplier * 12
            break;
        case 2:
            ResourcePerSecond = ResourceMultiplier * 10
            break;
        case 3:
            ResourcePerSecond = ResourceMultiplier * 8
            break;
        case 4:
            ResourcePerSecond = ResourceMultiplier * 7
            break;
        case 5:
            ResourcePerSecond = ResourceMultiplier * 6
            break;
        case 6:
            ResourcePerSecond = ResourceMultiplier * 5
            break;
        case 7:
            ResourcePerSecond = ResourceMultiplier * 4
            break;
        case 8:
            ResourcePerSecond = ResourceMultiplier * 3
            break;
        case 9:
            ResourcePerSecond = ResourceMultiplier * 2
            break;
        default:
            ResourcePerSecond = 1
            break;
        }
        
        print("Resources per second: ", ResourcePerSecond, " distance away from path: ", minDist)
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
