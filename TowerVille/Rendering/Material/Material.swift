//
//  Material.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

protocol Material {
    
    var shader : ShaderProgram { get }
    
    func LoadMaterial() -> Void
    
    func LoadLightData(fromLights lights : [Light])
    
}

// Consider: 
//class TextureMaterial {
//
//    var texture: GLuint = 0
//    var shader: ShaderProgram!
//
//    init (_ shader : ShaderProgram)
//    {
//        self.shader = shader
//    }
//
//    func loadTexture(_ filename: String) {
//
//        let path = Bundle.main.path(forResource: filename, ofType: nil)!
//        let option = [ GLKTextureLoaderOriginBottomLeft: true]
//        do {
//            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
//            self.texture = info.name
//        } catch {
//            NSLog("ERROR: Failed to load texture %s", filename)
//        }
//    }
//
//    func LoadMaterial() -> Void {
//        glActiveTexture(GLenum(GL_TEXTURE1))
//        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
//        glUniform1i(self.shader.textureUniform, 1)
//    }
//
//}

