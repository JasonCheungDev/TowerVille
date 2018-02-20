//
//  PhongMaterial.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class LambertMaterial : Material {
    var surfaceColor : Color  = Color(1,0,0,1)
    var lightColor : Color = Color(1,1,0,1)
    var lightDirection : Vertex = Vertex(-1, -1, -1)
    
    private var surfaceColorUniformLocation : Int32!
    private var lightColorUniformLocation : Int32!
    private var lightDirectionUniformLocation : Int32!
    private var textureUniformLocation : Int32!
    private var texture : GLuint = 0

    init (_ shader : ShaderProgram)
    {
        self.SetupAttributeLocations(shader)
    }

    func loadTexture(_ filename: String) {

        let path = Bundle.main.path(forResource: filename, ofType: nil)!
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            NSLog("ERROR: Failed to load texture %s", filename)
        }
    }
    
    func LoadMaterial() -> Void
    {
        glUniform4f(surfaceColorUniformLocation, surfaceColor.r, surfaceColor.g, surfaceColor.b, surfaceColor.a)
//        glUniform4f(lightColorUniformLocation, LightColor.r, LightColor.g, LightColor.b, LightColor.a)
//        glUniform3f(lightDirectionUniformLocation, 1, 1, 1)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
        glUniform1i(textureUniformLocation, 1)
    }
    
    private func SetupAttributeLocations(_ shader : ShaderProgram)
    {
        surfaceColorUniformLocation = glGetUniformLocation(shader.programHandle, "u_SurfaceColor")
//        lightColorUniformLocation = glGetUniformLocation(shader.programHandle, "lightColor");
//        lightDirectionUniformLocation = glGetUniformLocation(shader.programHandle, "lightDirection");
        textureUniformLocation = glGetUniformLocation(shader.programHandle, "u_Texture")
    }
}
