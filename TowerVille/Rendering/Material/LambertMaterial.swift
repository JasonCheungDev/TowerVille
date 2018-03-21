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
    
    private static let MAX_POINT_LIGHTS = 4
    
    var surfaceColor : Color  = Color(1,0,0,1)
    var specularPower : Float = 32
    
    private var hasTexture : GLint = 0
    
    private var surfaceColorUniformLocation : Int32!
    private var textureUniformLocation : Int32!
    private var texture : GLuint = 0
    private var specularPowerUniformLocation : Int32!
    private var hasTextureUniformLocation : Int32!
    
    private var directionalLightIntensityUniform : Int32!
    private var directionalLightDirectionUniform : Int32!
    private var directionalLightColorUniform     : Int32!
    private var pointLightPositionsUniform   = [Int32](repeating: 0, count: MAX_POINT_LIGHTS)
    private var pointLightColorsUniform      = [Int32](repeating: 0, count: MAX_POINT_LIGHTS)
    private var pointLightIntensitiesUniform = [Int32](repeating: 0, count: MAX_POINT_LIGHTS)
    
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
            hasTexture = 1
        } catch {
            NSLog("ERROR: Failed to load texture %s", filename)
        }
    }
    
    func LoadMaterial() -> Void
    {
        glUniform4f(surfaceColorUniformLocation, surfaceColor.r, surfaceColor.g, surfaceColor.b, surfaceColor.a)
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
        glUniform1i(textureUniformLocation, 1)
        glUniform1f(specularPowerUniformLocation, specularPower)
        glUniform1i(hasTextureUniformLocation, hasTexture)
    }
    
    func LoadLightData(fromLights lights: [Light]) {
        
        var pointLightCount = 0
        
        for light in lights {
            
            if let dLight = light as? DirectionalLight
            {
                glUniform1f(directionalLightIntensityUniform, dLight.lightIntensity)
                glUniform3f(directionalLightDirectionUniform, dLight.xDir, dLight.yDir, dLight.zDir)
                glUniform4f(directionalLightColorUniform, dLight.lightColor.r
                    , dLight.lightColor.g, dLight.lightColor.b, dLight.lightColor.a)
            }
            else if let pLight = light as? PointLight
            {
                var lightPos = GLKVector4Make(pLight.x, pLight.y, pLight.z, 1)
                lightPos = GLKMatrix4MultiplyVector4(Camera.ActiveCamera!.viewMatrix, lightPos)

                glUniform1f(pointLightIntensitiesUniform[pointLightCount], pLight.lightIntensity)
                glUniform3f(pointLightPositionsUniform[pointLightCount], lightPos.x, lightPos.y, lightPos.z)
                glUniform4f(pointLightColorsUniform[pointLightCount], pLight.lightColor.r
                    , pLight.lightColor.g, pLight.lightColor.b, pLight.lightColor.a)
                pointLightCount += 1
            }
            
            if (pointLightCount >= LambertMaterial.MAX_POINT_LIGHTS)
            {
                return;
            }
        }
    }
    
    private func SetupAttributeLocations(_ shader : ShaderProgram)
    {
        // surface
        surfaceColorUniformLocation = glGetUniformLocation(shader.programHandle, "u_SurfaceColor")
        textureUniformLocation = glGetUniformLocation(shader.programHandle, "u_Texture")
        hasTextureUniformLocation = glGetUniformLocation(shader.programHandle, "u_HasTexture")
        specularPowerUniformLocation = glGetUniformLocation(shader.programHandle, "u_SpecularPower")
        
        // lighting 
        directionalLightDirectionUniform = glGetUniformLocation(shader.programHandle, "u_DirectionalLight.direction")
        directionalLightColorUniform = glGetUniformLocation(shader.programHandle, "u_DirectionalLight.color")
        directionalLightIntensityUniform = glGetUniformLocation(shader.programHandle, "u_DirectionalLight.intensity")
        
        for i in 0..<LambertMaterial.MAX_POINT_LIGHTS {
            pointLightPositionsUniform[i] = glGetUniformLocation(shader.programHandle, "u_PointLights[\(i)].position")
            pointLightColorsUniform[i] = glGetUniformLocation(shader.programHandle, "u_PointLights[\(i)].color")
            pointLightIntensitiesUniform[i] = glGetUniformLocation(shader.programHandle, "u_PointLights[\(i)].intensity")
            
        }
    }
}
