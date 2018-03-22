//
//  Map.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class Map {
    
    var Tiles : [[Tile]] = []
    
    private var shader : ShaderProgram?
    
    // TODO: Change to init. Shouldn't work more than once I guess
    func setupMap(fromShader shader: ShaderProgram, mapSize mapSize: Int) {
        
        self.shader = shader
        
        let gridSize = mapSize * 2 - 1
        
        // create some materials
        let grassTileMat = LambertMaterial(shader)
        grassTileMat.surfaceColor = Color(0,1,0,1)
        
        let mountainTileMat = LambertMaterial(shader)
        mountainTileMat.surfaceColor = Color(0,0,0,1)
        
        let highlightOrigin = LambertMaterial(shader)
        highlightOrigin.surfaceColor = Color(1,0,0,1)
        
        // create shared RO
        let grassRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        grassRo.material = grassTileMat
        
        let mountainRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        mountainRo.material = mountainTileMat
        
        let highlightRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        highlightRo.material = highlightOrigin
        
        for x in 0..<gridSize {
            
            Tiles.append([])

            for y in 0..<gridSize {

                let newTile = Tile()
                newTile.x = Float(x)
                newTile.z = Float(-y)

                if (x + y >= gridSize / 2 && x + y < gridSize + gridSize / 2 && abs(x - y) <= gridSize / 2)
                {
                    // on screen
                    if (x + y == gridSize / 2 || x + y == gridSize + gridSize / 2 - 1 || abs(x - y) == gridSize / 2)
                    {
                        // border
                        newTile.linkRenderObject(mountainRo)
                        newTile.type = TileType.Mountain
                    } else {
                        // rest
                        newTile.linkRenderObject(grassRo)
                        newTile.type = TileType.Grass
                    }
                }
                else
                {
                    // off screen
                    // don't add RO or mat
                    newTile.type = TileType.Mountain // prevent building on this tile
                }
                
                Tiles[x].append(newTile)
            }
        }
    }
    
    
    func setupPathFromWaypoints(waypoints : [GameObject])
    {
        let pathMat = LambertMaterial(shader!);
        pathMat.surfaceColor = Color(0.5, 0.5, 0.5, 1.0);
        let pathRo = RenderObject(fromShader: shader!, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        pathRo.material = pathMat
        
        var curX = Int(waypoints[0].x);
        var curZ = -Int(waypoints[0].z);
        
        // do first tile path manually
        Tiles[curX][curZ].linkRenderObject(pathRo);
        Tiles[curX][curZ].type = .Path;
        
        for index in 1 ..< waypoints.count {
            let wp = waypoints[index];
            let x = Int(wp.x);
            let z = -Int(wp.z);
            
            while ( !(curX == x && curZ == z) )
            {
                let moveX = clamp(x - curX, -1, 1);
                let moveZ = clamp(z - curZ, -1, 1);
                
                curX += moveX;
                curZ += moveZ;
                
                Tiles[curX][curZ].linkRenderObject(pathRo);
                Tiles[curX][curZ].type = .Path;
            }
        }
    }
}
