//
//  ResourceGenerator.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-22.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

// Consider: Extending "Structure" object (may be unneccessary inheritance though)
protocol ResourceGenerator {
    
    var Health : Int { get set }
    var ResourcePerSecond : Int { get set }
    
    func ProduceResource() -> Void
}
