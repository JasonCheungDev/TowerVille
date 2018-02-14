//
//  PhongMaterial.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class PhongMaterial : Material {
    var Ambient : Color  = Color(1,0,0,1)
    var Diffuse : Color  = Color(0,1,0,1)
    var Specular : Color = Color(0,0,1,1)
    var LightColor : Color = Color(1,1,0,1)
    
    private var ambientUniformLocation : Int32!
    private var diffuseUniformLocation : Int32!
    private var specularUniformLocation : Int32!
    private var lightColorUniformLocation : Int32!
    private var lightDirectionUniformLocation : Int32!

    init (_ shader : ShaderProgram)
    {
        SetupAttributeLocations(shader)
    }
    
    func LoadMaterial() -> Void
    {
        glUniform4f(ambientUniformLocation, Ambient.r, Ambient.g, Ambient.b, Ambient.a)
        glUniform4f(lightColorUniformLocation, Diffuse.r, Diffuse.g, Diffuse.b, Diffuse.a)
        glUniform3f(lightDirectionUniformLocation, 1, 1, 1)
    }
    
    private func SetupAttributeLocations(_ shader : ShaderProgram)
    {
        ambientUniformLocation = glGetUniformLocation(shader.programHandle, "ambientColor")
        lightColorUniformLocation = glGetUniformLocation(shader.programHandle, "lightColor");
        lightDirectionUniformLocation = glGetUniformLocation(shader.programHandle, "lightDirection");
    }
}
