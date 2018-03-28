//
//  Map.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class Map : VisualObject {
    
    var Tiles : [[Tile]] = []
    
    private var shader : ShaderProgram!
    private var mergedGrassVO    : VisualObject?
    private var mergedMountainVO : VisualObject?
    private var mergedPathVO     : VisualObject?
    
    
    init(fromShader shader : ShaderProgram, mapSize : Int)
    {
        super.init()
        self.shader = shader
        setupMap(mapSize: mapSize)
    }
    
    override func draw() {

        // efficient draw
        if mergedGrassVO != nil
        {
            mergedGrassVO?.draw()
            mergedMountainVO?.draw()
            mergedPathVO?.draw()
        }
        // standard draw
        else
        {
            Tiles.forEach({ $0.forEach({ $0.draw() })})
        }
    }
    
    func setupMap(mapSize: Int) {

        self.Tiles.removeAll()
        
        let gridSize = mapSize * 2 - 1
        
        // create some materials
        let grassTileMat = GenericMaterial(shader)
        grassTileMat.surfaceColor = Color(0,1,0,1)

        let mountainTileMat = GenericMaterial(shader)
        mountainTileMat.surfaceColor = Color(0,0,0,1)
                
        // create shared RO
        let grassRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        
        let mountainRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        
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
                        newTile.renderObject = mountainRo
                        newTile.material = mountainTileMat
                        newTile.type = TileType.Mountain
                    } else {
                        // rest
                        newTile.renderObject = grassRo
                        newTile.material = grassTileMat
                        newTile.type = TileType.Grass
                    }
                }
                else
                {
                    // off screen
                    // don't add RO or mat
                    newTile.type = TileType.NOTHING // prevent building on this tile
                }
                
                Tiles[x].append(newTile)
            }
        }
    }
    
    func setupPathFromWaypoints(waypoints : [GameObject])
    {
        let pathMat = GenericMaterial(shader!)
        pathMat.surfaceColor = Color(0.5, 0.5, 0.5, 1.0)
        
        let pathRo = RenderObject(fromShader: shader!, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        
        var curX = Int(waypoints[0].x)
        var curZ = -Int(waypoints[0].z)
        
        // do first tile path manually
        Tiles[curX][curZ].renderObject = pathRo
        Tiles[curX][curZ].material = pathMat
        Tiles[curX][curZ].type = .Path
        
        for index in 1 ..< waypoints.count {
            let wp = waypoints[index]
            let x = Int(wp.x)
            let z = -Int(wp.z)
            
            while ( !(curX == x && curZ == z) )
            {
                let moveX = clamp(x - curX, -1, 1)
                let moveZ = clamp(z - curZ, -1, 1)
                
                curX += moveX
                curZ += moveZ
                
                Tiles[curX][curZ].renderObject = pathRo
                Tiles[curX][curZ].material = pathMat
                Tiles[curX][curZ].type = .Path
            }
        }
    }

    // call this function when the map is fully setup to improve performance
    func compress()
    {
        self.mergedMountainVO = mergeVisualObjects(fromVisualObjects: Tiles.flatMap({$0}).filter({ $0.type == .Mountain }))
        
        self.mergedGrassVO = mergeVisualObjects(fromVisualObjects: Tiles.flatMap({$0}).filter({ $0.type == .Grass }))

        self.mergedPathVO = mergeVisualObjects(fromVisualObjects: Tiles.flatMap({$0}).filter({ $0.type == .Path }))
    }
    
    func clearAllStructures()
    {
        Tiles.forEach({ $0.forEach({ $0.structure = nil })})
    }
    
    private func mergeVisualObjects(fromVisualObjects VOs : [VisualObject]) -> VisualObject
    {
        var vertices : [VertexData] = []
        var indices : [GLushort] = []
        
        for v in VOs
        {
            if v.renderObject == nil { continue }
            
            // 1. add index data
            let indexStart = vertices.count // vertex count not index!
            for i in v.renderObject!.Indices {
                indices.append(i + GLushort(indexStart))
            }
            
            // 2. add vertex data
            for vd in v.renderObject!.VertexDatas {
                
                vertices.append(
                    VertexData(vd.x + v.x, vd.y + v.y, vd.z + v.z,
                               vd.r, vd.g, vd.b, vd.a,
                               vd.u, vd.v,
                               vd.nx, vd.ny, vd.nz)
                )
                
            }
        }
        
        // create VO w/ shared data
        let ro = RenderObject(fromShader: shader!, fromVertices: vertices, fromIndices: indices)
        let mat = VOs.first?.material
        return VisualObject(ro, mat!)
    }
}
