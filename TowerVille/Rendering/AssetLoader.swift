//
//  AssetLoader.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-04-01.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

enum Assets : String
{
    case MAT_GRASS = "mat_grass"
    case MAT_PATH = "mat_path"
    case MAT_MOUNTAIN = "mat_mountain"
    case MAT_TOWER = "mat_tower"
    
    case RO_FARM = "ro_farm"
    case RO_SAWMILL = "ro_sawmill"
    case RO_MINE = "ro_mine"
    case RO_TOWER = "ro_tower"
    case RO_CUBE = "ro_cube"
    case RO_RECTANGLE = "ro_rectangle"
    
}

class AssetLoader
{
    var Instance : AssetLoader = AssetLoader()
    var materials : [String : Material] = [:]
    var renderObjects : [String : RenderObject] = [:]
    var shader : ShaderProgram?
    
    // MARK:- Initialization
    
    init() { }
    
    func SetShader(shader : ShaderProgram)
    {
        self.shader = shader
    }
    
    // call this function initialize all prefab assets
    func LoadAssets()
    {
        if shader == nil
        {
            NSLog("ERROR: Attempting to load assets without a shader. Call SetShader(...) first.")
            return;
        }
        
        //
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
    
    func CreateVisualObject(id : String) -> VisualObject
    {
        var vo = VisualObject()
        return vo
    }
    
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
    
    func RegisterVisualObject(id : String, matId : String, roId : String) -> Bool
    {
        // TODO STUB
        return false
    }
}
