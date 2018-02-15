//
//  LambertMaterial.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class FlatColorMaterial : Material{
    
    var color : Color = Color(1,0,0,1)
    
    private var colorUniformLocation : Int32!
    
    init (_ shader : ShaderProgram)
    {
        SetupAttributeLocations(shader)
    }
    
    func LoadMaterial() -> Void
    {
        glUniform4f(colorUniformLocation, color.r, color.g, color.b, color.a)
    }
    
    private func SetupAttributeLocations(_ shader : ShaderProgram)
    {
        colorUniformLocation = glGetUniformLocation(shader.programHandle, "u_Color")
    }
}
