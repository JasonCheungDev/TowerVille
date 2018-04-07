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
                        newTile.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_MOUNTAIN.rawValue)
                        newTile.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_MOUNTAIN.rawValue)
                        newTile.type = TileType.Mountain
                        newTile.setScale(0.5)
                    } else {
                        // rest
                        newTile.renderObject = AssetLoader.Instance.GetRenderObject(id: Assets.RO_TILE.rawValue)
                        newTile.material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_GRASS.rawValue)
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
        var curX = Int(waypoints[0].x)
        var curZ = -Int(waypoints[0].z)
        
        // do first tile path manually
        Tiles[curX][curZ].material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_PATH.rawValue)
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
                
                Tiles[curX][curZ].material = AssetLoader.Instance.GetMaterial(id: Assets.MAT_PATH.rawValue)
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
            let m = v.renderObject!.modelMatrix(v)
            let mm = m.m
            for vd in v.renderObject!.VertexDatas {
                let oldPos = GLKVector4Make(vd.x, vd.y, vd.z, 1)
                let oldNrm = GLKVector4Make(vd.nx, vd.ny, vd.nz, 1)
                let newPos = GLKMatrix4MultiplyVector4(m, oldPos)
                let newNrm = GLKMatrix4MultiplyVector4(m, oldNrm)
                let x1 = vd.x + v.x
                let y1 = vd.y + v.y
                let z1 = vd.z + v.z
                let x2 = oldPos.x
                let y2 = oldPos.y
                let z2 = oldPos.z
                let x3 = newPos.x
                let y3 = newPos.y
                let z3 = newPos.z
                
                vertices.append(
                    VertexData(newPos.x, newPos.y, newPos.z,
                               vd.r, vd.g, vd.b, vd.a,
                               vd.u, vd.v,
                               vd.nx, vd.ny, vd.nz)
                               //newNrm.x, newNrm.y, newNrm.z)
                )
            }
        }
        
        // create VO w/ shared data
        let ro = RenderObject(fromShader: shader!, fromVertices: vertices, fromIndices: indices)
        let mat = VOs.first?.material
        return VisualObject(ro, mat!)
    }
}
