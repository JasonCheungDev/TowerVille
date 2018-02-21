//
//  ObjLoader.swift
//  TowerVille
//
//  Created by Markus  on 2018-02-20.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class ObjLoader {
    var vertexArray = [GLKVector3]()
    var textureArray = [GLKVector2]()
    var normalArray = [GLKVector3]()
    
    var vertexDataArray = [VertexData]()
    var vertexDataIndex : GLubyte = 0
    var indexDataArray = [GLubyte]()
    
    func Read(fileName : String) -> Void{
        if let path = Bundle.main.path(forResource: fileName, ofType: "obj") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for line in lines {
                    if (line.hasPrefix("v ")) {
                        ReadVertex(line)
                    } else if (line.hasPrefix("vt ")) {
                        ReadTexture(line)
                    } else if (line.hasPrefix("vn ")) {
                        ReadNormal(line)
                    } else if (line.hasPrefix("f ")) {
                        ReadFace(line)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func ReadVertex(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let x = Float(strings[1])!
        let y = Float(strings[2])!
        let z = Float(strings[3])!
        let vector3 = GLKVector3Make(x, y, z)
        vertexArray.append(vector3)
    }
    
    func ReadTexture(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let u = Float(strings[1])!
        let v = Float(strings[2])!
        let vector2 = GLKVector2Make(u, v)
        textureArray.append(vector2)
    }
    
    func ReadNormal(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let i = Float(strings[1])!
        let j = Float(strings[2])!
        let k = Float(strings[3])!
        let vector3 = GLKVector3Make(i, j, k)
        normalArray.append(vector3)
    }
    
    func ReadFace(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        strings.removeFirst()
        for string in strings {
            var a = string.components(separatedBy: "/")
            let vertexIndex = Int(a[0])! - 1
            let textureIndex = Int(a[1])! - 1
            let normalIndex = Int(a[2])! - 1
            let vertex = vertexArray[vertexIndex]
            let texture = textureArray[textureIndex]
            let normal = normalArray[normalIndex]
            let vertexData = VertexData.init(vertex.x, vertex.y, vertex.z, 0.0, 0.0, 0.0, 1.0, texture.x, texture.y, normal.x, normal.y, normal.z)
            vertexDataArray.append(vertexData)
            indexDataArray.append(vertexDataIndex)
            vertexDataIndex += 1
        }
    }
    
}

