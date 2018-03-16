//
//  Helpers.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-14.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

func clamp<T: Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
    return min(max(value, lower), upper)
}
