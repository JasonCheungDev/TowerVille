//
//  ColorLerper.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-04-17.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

class ColorLerper
{
    var colors : [Color] = []
    var timeToNextColor : Float = 2
    var t : Float = 0
    var index = 0
    
    init(delay: Float = 2)
    {
        timeToNextColor = delay
    }
    
    func Add(color : Color)
    {
        colors.append(color)
    }
    
    func Update(deltaTime : Float)
    {
        t += deltaTime/timeToNextColor
        if t > 1.0
        {
            t -= 1.0
            
            index += 1
            if index >= colors.count
            {
                index = 0
            }
        }
    }
    
    func GetColor() -> Color
    {
        return ColorLerper.Lerp(
            colorA: colors[index],
            colorB: (index == colors.count - 1) ? colors[0] : colors[index+1],
            t: t)
    }
    
    class func Lerp(colorA : Color, colorB : Color, t : Float) -> Color
    {
        return Color(
            colorA.r + (colorB.r - colorA.r) * t,
            colorA.g + (colorB.g - colorA.g) * t,
            colorA.b + (colorB.b - colorA.b) * t,
            1.0)
    }
}
