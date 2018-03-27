//
//  IceProjectile.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-10.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

class IceProjectile : TowerProjectile
{
    
    
    override init(_ x: GLfloat, _ z: GLfloat, shader: ShaderProgram, target: Minion) {
        super.init(x, z, shader: shader, target: target)
        
        let mat = self.material as! LambertMaterial
        mat.surfaceColor = Color(0,0,1,1) //blue
        
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = IceProjectile(self.x, self.z, shader: shader, target: self.target)
        return copy
    }
    
}
