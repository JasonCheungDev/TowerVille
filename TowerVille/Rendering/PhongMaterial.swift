//
//  PhongMaterial.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-14.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class PhongMaterial : Material {
    var SurfaceColor : Color  = Color(1,0,0,1)
    var LightColor : Color = Color(1,1,0,1)
    var LightDirection : Vertex = Vertex(-1, -1, -1)
    
    private var surfaceColorUniformLocation : Int32!
    private var lightColorUniformLocation : Int32!
    private var lightDirectionUniformLocation : Int32!
    
    init (_ shader : ShaderProgram)
    {
        SetupAttributeLocations(shader)
    }
    
    func LoadMaterial() -> Void
    {
        glUniform4f(surfaceColorUniformLocation, SurfaceColor.r, SurfaceColor.g, SurfaceColor.b, SurfaceColor.a)
//        glUniform4f(lightColorUniformLocation, LightColor.r, LightColor.g, LightColor.b, LightColor.a)
//        glUniform3f(lightDirectionUniformLocation, 1, 1, 1)
    }
    
    private func SetupAttributeLocations(_ shader : ShaderProgram)
    {
        surfaceColorUniformLocation = glGetUniformLocation(shader.programHandle, "u_SurfaceColor")
//        lightColorUniformLocation = glGetUniformLocation(shader.programHandle, "lightColor");
//        lightDirectionUniformLocation = glGetUniformLocation(shader.programHandle, "lightDirection");
    }
}
