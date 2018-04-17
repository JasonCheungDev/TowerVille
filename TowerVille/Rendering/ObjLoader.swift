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
    var calculate_normals = false
    
    private var vertexArray = [GLKVector3]()
    private var textureArray = [GLKVector2]()
    private var normalArray = [GLKVector3]()
    private var hash = [VertexData : GLushort]()
    var vertexDataArray = [VertexData]()
    var indexDataArray = [GLushort]()
    
    func Read(fileName : String) -> Void{
        vertexArray.removeAll()
        textureArray.removeAll()
        normalArray.removeAll()
        vertexDataArray.removeAll()
        indexDataArray.removeAll()
        if let path = Bundle.main.path(forResource: fileName, ofType: "obj") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for line in lines {
                    if (line.hasPrefix("v ")) {
                        ReadVertex(line)
                    } else if (line.hasPrefix("vt ")) {
                        ReadTexture(line)
                    } else if (!calculate_normals && line.hasPrefix("vn ")) {
                        ReadNormal(line)
                    } else if (line.hasPrefix("f ")) {
                        ReadFace(line)
                    }
                }
                if (calculate_normals || normalArray.count == 0) {
                    CalculateNormals() // if no normals provided manually calculate them
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func CalculateNormals() -> Void{
        for i in 0..<indexDataArray.count/3 {
            let v1_index = Int(indexDataArray[i*3])
            let v2_index = Int(indexDataArray[i*3+1])
            let v3_index = Int(indexDataArray[i*3+2])
            
            let v1 = vertexDataArray[v1_index]
            let v2 = vertexDataArray[v2_index]
            let v3 = vertexDataArray[v3_index]
            
            var U = GLKVector3()
            U.x = v2.x - v1.x
            U.y = v2.y - v1.y
            U.z = v2.z - v1.z
            
            var V = GLKVector3()
            V.x = v3.x - v1.x
            V.y = v3.y - v1.y
            V.z = v3.z - v1.z
            
            var normal = GLKVector3CrossProduct(U, V)
            
            vertexDataArray[v1_index].nx += normal.x
            vertexDataArray[v1_index].ny += normal.y
            vertexDataArray[v1_index].nz += normal.z
            
            vertexDataArray[v2_index].nx += normal.x
            vertexDataArray[v2_index].ny += normal.y
            vertexDataArray[v2_index].nz += normal.z
            
            vertexDataArray[v3_index].nx += normal.x
            vertexDataArray[v3_index].ny += normal.y
            vertexDataArray[v3_index].nz += normal.z
        }
    }
    
    private func ReadVertex(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let x = Float(strings[1])!
        let y = Float(strings[2])!
        let z = Float(strings[3])!
        let vector3 = GLKVector3Make(x, y, z)
        vertexArray.append(vector3)
    }
    
    private func ReadTexture(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let u = Float(strings[1])!
        let v = Float(strings[2])!
        let vector2 = GLKVector2Make(u, v)
        textureArray.append(vector2)
    }
    
    private func ReadNormal(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        let i = Float(strings[1])!
        let j = Float(strings[2])!
        let k = Float(strings[3])!
        var vector3 = GLKVector3Make(i, j, k)
        vector3 = GLKVector3Normalize(vector3)
        normalArray.append(vector3)
    }
    
    private func ReadFace(_ line : String) -> Void{
        var strings = line.components(separatedBy: " ")
        strings.removeFirst()
        
        var faceIndices : [GLushort] = []   // track indices in case of quad
        
        for string in strings {
            var a = string.components(separatedBy: "/")
            var vertexData = VertexData(0,0,0,0,0,0,0,0);
            
            // setup verticfes
            let vIndex = Int(a[0])! - 1
            vertexData.x = vertexArray[vIndex].x
            vertexData.y = vertexArray[vIndex].y
            vertexData.z = vertexArray[vIndex].z
            // setup texture coordinates
            if a.count >= 2, let tIndex = Int(a[1]) {
                vertexData.u = textureArray[tIndex-1].x
                vertexData.v = textureArray[tIndex-1].y
            }
            // setup normals
            if !calculate_normals, a.count == 3, let nIndex = Int(a[2])
            {
                vertexData.nx = normalArray[nIndex-1].x
                vertexData.ny = normalArray[nIndex-1].y
                vertexData.nz = normalArray[nIndex-1].z
            }
            
            // see if data exists already 
            if let index = hash[vertexData]
            {
                indexDataArray.append(index)
                faceIndices.append(index)
            }
            else
            {
                let newIndex = GLushort(vertexDataArray.count)
                indexDataArray.append(newIndex)
                vertexDataArray.append(vertexData)
                hash[vertexData] = newIndex
                faceIndices.append(newIndex)
            }
        }
        
        // if face is a quad break it down to a triangle
        if (strings.count == 4) {
            indexDataArray.append(faceIndices[0])
            indexDataArray.append(faceIndices[2])
        }
    }
    
}


