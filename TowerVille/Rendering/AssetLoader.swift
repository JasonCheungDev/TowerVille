//
//  AssetLoader.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-04-01.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

/*
EXAMPLE USAGE
 
 // 1. Preload formal assets (done in PlayState right now)
 AssetLoader.Instance.PreloadAssets(shader)
 
 // 2. retrieve a formal asset
 let ro = AssetLoader.Instance.GetRenderObject(
                Assets.RO_RAT.rawValue)
 let mat = AssetLoader.Instance.GetMaterial(
                Assets.MAT_RAT.rawValue)
 
 // 3. register your own asset (same for RenderObject)
 let myMat = GenericMaterial(shader)
 myMat.loadTexture("cool_texture.png")
 myMat.surfaceColor = Color(1, 1, 1, 1)
 myMat.specularPower = 64;
 
 let success = AssetLoader.Instance.RegisterMaterial(id: "my_id", mat: myMat)

 // 4. retrieve an added asset
 let theMat = AssetLoader.Instance.GetMaterial("my_id")
 */

import Foundation

// formal list of assets AssetLoader preloads
enum Assets : String
{
    case RO_RAT = "ro_rat"
    case RO_HOPPER = "ro_hopper"
    case RO_PLANE = "ro_plane"
    case RO_FARM = "ro_farm"
    case RO_SAWMILL = "ro_sawmill"
    case RO_MINE = "ro_mine"
    case RO_TOWER = "ro_tower"
    case RO_CUBE = "ro_cube"
    case RO_TILE = "ro_tile"
    
    case MAT_GRASS = "mat_grass"
    case MAT_PATH = "mat_path"
    case MAT_MOUNTAIN = "mat_mountain"
    case MAT_RAT = "mat_rat"
    case MAT_HOPPER = "mat_hopper"
    case MAT_PLANE = "mat_plane"
    case MAT_FARM = "mat_farm"
    case MAT_SAWMILL = "mat_sawmill"
    case MAT_MINE = "mat_mine"
    case MAT_TWR = "mat_tower"
    case MAT_TWR_SLOW = "mat_tower_slow"
    case MAT_TWR_EXPLODE = "mat_tower_explode"
    case MAT_TWR_FRAG = "mat_tower_fragmentation"
    case MAT_TWR_LASER = "mat_tower_laser"
}

class AssetLoader
{
    static var Instance : AssetLoader = AssetLoader()
    var materials : [String : Material] = [:]
    var renderObjects : [String : RenderObject] = [:]
    // var visualObjects : [String : (ro:RenderObject, mat:Material)] = [:]
    
    // MARK:- Initialization
    
    init() { }
    
    // call this function initialize all prefab assets
    func PreloadAssets(shader : ShaderProgram)
    {
        if shader == nil
        {
            NSLog("ERROR: Attempting to load assets without a shader. Call SetShader(...) first.")
            return;
        }
    
        NSLog("AssetLoader: Starting asset preload")
        let startTime = Date()

        // RENDER OBJECTS
        var objLoader = ObjLoader()
        
        objLoader.Read(fileName: "rat")
        let roRat = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_RAT.rawValue] = roRat
        
        objLoader.Read(fileName: "grassHopper")
        let roHopper = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_HOPPER.rawValue] = roHopper
        
        objLoader.Read(fileName: "plane")
        let roPlane = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_PLANE.rawValue] = roPlane
        
        objLoader.Read(fileName: "farm")
        let roFarm = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_FARM.rawValue] = roFarm
        
        objLoader.Read(fileName: "sawmill")
        let roSawmill = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_SAWMILL.rawValue] = roSawmill
        
        objLoader.Read(fileName: "mine")
        let roMine = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_MINE.rawValue] = roMine
        
        objLoader.smoothed = false
        objLoader.calculate_normals = true
        objLoader.Read(fileName: "rook")
        let roTower = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        renderObjects[Assets.RO_TOWER.rawValue] = roTower
        
        let roCube = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        renderObjects[Assets.RO_CUBE.rawValue] = roCube
        
        let roTile = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        renderObjects[Assets.RO_TILE.rawValue] = roTile

        // MATERIALS
        let grassTileMat = GenericMaterial(shader)
        grassTileMat.surfaceColor = Color(0,1,0,1)
        materials[Assets.MAT_GRASS.rawValue] = grassTileMat

        let mountainTileMat = GenericMaterial(shader)
        mountainTileMat.surfaceColor = Color(0,0,0,1)
        materials[Assets.MAT_MOUNTAIN.rawValue] = mountainTileMat

        let pathMat = GenericMaterial(shader)
        pathMat.surfaceColor = Color(0.5, 0.5, 0.5, 1.0)
        materials[Assets.MAT_PATH.rawValue] = pathMat

        let matRat = GenericMaterial(shader)
        matRat.surfaceColor = Color(105/255,105/255,105/255,1)
        materials[Assets.MAT_RAT.rawValue] = matRat

        let matHopper = GenericMaterial(shader)
        matHopper.surfaceColor = Color(0,1,0,1)
        materials[Assets.MAT_HOPPER.rawValue] = matHopper

        let matPlane = GenericMaterial(shader)
        matPlane.surfaceColor = Color(1,140/255,0,1)
        materials[Assets.MAT_PLANE.rawValue] = matPlane
        
        let matFarm = GenericMaterial(shader)
        matFarm.loadTexture("farm.png")
        matFarm.surfaceColor = Color(1, 1, 1, 1)
        matFarm.specularPower = 1;
        materials[Assets.MAT_FARM.rawValue] = matFarm
        
        let matSawmill = GenericMaterial(shader)
        matSawmill.surfaceColor = Color(133/255, 94/255, 66/255, 1)
        matSawmill.specularPower = 1;
        materials[Assets.MAT_SAWMILL.rawValue] = matSawmill
        
        let matMine = GenericMaterial(shader)
        matMine.surfaceColor = Color(133/255, 94/255, 66/255, 1)
        matMine.specularPower = 1;
        materials[Assets.MAT_MINE.rawValue] = matMine
    
        let matTowerBasic = GenericMaterial(shader)
        matTowerBasic.surfaceColor = Color(0.5, 0.5, 0.5, 1)
        materials[Assets.MAT_TWR.rawValue] = matTowerBasic
    
        let matTowerSlow = GenericMaterial(shader)
        matTowerSlow.surfaceColor = Color(0, 0, 1, 1)
        materials[Assets.MAT_TWR_SLOW.rawValue] = matTowerSlow
        
        let matTowerExplode = GenericMaterial(shader)
        matTowerExplode.surfaceColor = Color(1, 0.3, 0, 1)
        materials[Assets.MAT_TWR_EXPLODE.rawValue] = matTowerExplode
        
        let matTowerFrag = GenericMaterial(shader)
        matTowerFrag.surfaceColor = Color(0, 1, 1, 1)
        materials[Assets.MAT_TWR_FRAG.rawValue] = matTowerFrag
        
        let matTowerLaser = GenericMaterial(shader)
        matTowerLaser.surfaceColor = Color(1, 0, 0, 1)
        materials[Assets.MAT_TWR_LASER.rawValue] = matTowerLaser
    
        let loadTime = startTime.timeIntervalSinceNow
        NSLog("AssetLoader: Preload finished. Took %.2f seconds.", loadTime)
    }
    
    // MARK:- Data retrieval
    
    func GetMaterial(id : String) -> Material?
    {
        return materials[id];
    }
    
    func GetRenderObject(id : String) -> RenderObject?
    {
        return renderObjects[id];
    }
    
//    func CreateVisualObject(id : String) -> VisualObject?
//    {
//        if let data = visualObjects[id]
//        {
//            var vo = VisualObject()
//            vo.renderObject = data.ro
//            vo.material = data.mat
//            return vo
//        }
//        else
//        {
//            return nil
//        }
//    }
    
    // MARK:- Data registration
    
    func RegisterMaterial(id : String, mat : Material) -> Bool
    {
        if materials[id] != nil { return false }
        materials[id] = mat
        return true
    }
    
    func RegisterRenderObject(id : String, ro : RenderObject) -> Bool
    {
        if renderObjects[id] != nil { return false }
        renderObjects[id] = ro
        return true
    }
    
//    func RegisterVisualObject(id : String, ro : RenderObject, mat : Material) -> Bool
//    {
//        if visualObjects[id] != nil { return false }
//        let data = (ro:ro, mat:mat)
//        visualObjects[id] = data
//        return true
//    }
}
