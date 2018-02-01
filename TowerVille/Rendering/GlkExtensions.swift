//
//  GlkExtensions.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-01-26.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import GLKit

extension GLKMatrix2 {
    var array: [Float] {
        return (0..<4).map { i in
            self[i]
        }
    }
}


extension GLKMatrix3 {
    var array: [Float] {
        return (0..<9).map { i in
            self[i]
        }
    }
}

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

