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
    var smoothed = false
    
    var vertexArray = [GLKVector3]()
    var textureArray = [GLKVector2]()
    var normalArray = [GLKVector3]()
    
    var vertexDataArray = [VertexData]()
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
                if (normalArray.count == 0) {
                    CalculateNormals() // if no normals provided manually calculate them
                }
            } catch {
                print(error)
            }
        }
    }
    
    func CalculateNormals() -> Void{
        for i in 0..<indexDataArray.count/3 {
            let v1_index = indexDataArray[i*3]
            let v2_index = indexDataArray[i*3+1]
            let v3_index = indexDataArray[i*3+2]
            
            let v1 = vertexDataArray[Int(v1_index)]
            let v2 = vertexDataArray[Int(v2_index)]
            let v3 = vertexDataArray[Int(v3_index)]
            
            var U = GLKVector3()
            U.x = v2.x - v1.x
            U.y = v2.y - v1.y
            U.z = v2.z - v1.z
            
            var V = GLKVector3()
            V.x = v3.x - v1.x
            V.y = v3.y - v1.y
            V.z = v3.z - v1.z
            
            var normal = GLKVector3CrossProduct(U, V)
            
            vertexDataArray[Int(v1_index)].nx += normal.x
            vertexDataArray[Int(v1_index)].ny += normal.y
            vertexDataArray[Int(v1_index)].nz += normal.z
            
            vertexDataArray[Int(v2_index)].nx += normal.x
            vertexDataArray[Int(v2_index)].ny += normal.y
            vertexDataArray[Int(v2_index)].nz += normal.z
            
            vertexDataArray[Int(v3_index)].nx += normal.x
            vertexDataArray[Int(v3_index)].ny += normal.y
            vertexDataArray[Int(v3_index)].nz += normal.z
        }
    }
    
    func ReadVertex(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let x = Float(strings[1])!
        let y = Float(strings[2])!
        let z = Float(strings[3])!
        let vector3 = GLKVector3Make(x, y, z)
        vertexArray.append(vector3)
        
        // if model is smoothed vertices don't need to be duplicate
        // and can be added immediately
        if (smoothed) {
            let vertexIndex = vertexArray.count - 1
            let vertex = vertexArray[vertexIndex]
            let vertexData = VertexData.init(vertex.x, vertex.y, vertex.z)
            vertexDataArray.append(vertexData)
        }
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
        var vector3 = GLKVector3Make(i, j, k)
        vector3 = GLKVector3Normalize(vector3)
        normalArray.append(vector3)
    }
    
    func ReadFace(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        strings.removeFirst()
        for string in strings {
            var a = string.components(separatedBy: "/")
            
            // choose vertexDataArray index to set values at
            var vertexIndex = Int(a[0])! - 1
            if (!smoothed) {
                let vertex = vertexArray[vertexIndex]
                vertexIndex = vertexDataArray.count
                let vertexData = VertexData.init(vertex.x, vertex.y, vertex.z)
                vertexDataArray.append(vertexData)
            }
            
            indexDataArray.append(GLubyte(vertexIndex))
            
            // if UVs provided set them in vertexDataArray
            if (a.count >= 2) {
                let textureIndex = Int(a[1])
                if (textureIndex != nil) {
                    let texture = textureArray[textureIndex! - 1]
                    vertexDataArray[vertexIndex].v = texture.x
                    vertexDataArray[vertexIndex].u = texture.y
                }
            }
            
            // if normal provided set it in vertexDataArray
            if (a.count == 3) {
                let normalIndex = Int(a[2])
                if (normalIndex != nil) {
                    let normal = normalArray[normalIndex! - 1]
                    vertexDataArray[vertexIndex].nx += normal.x
                    vertexDataArray[vertexIndex].ny += normal.y
                    vertexDataArray[vertexIndex].nz += normal.z
                }
            }
        }
        if (strings.count == 4) {
            var count = indexDataArray.count
            
            indexDataArray.append(indexDataArray[count - 4])
            indexDataArray.append(indexDataArray[count - 2])
        }
    }
    
}

