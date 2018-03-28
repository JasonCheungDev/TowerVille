//
//  HoppingMinion.swift
//  TowerVille
//
//  Created by SwordArt on 2018-03-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//


import Foundation

class HoppingMinion : Minion
{
    var timeElapsed : Float = 0.0
    var amplitude : Float = 1       //the amplitude, the peak deviation of the function from zero.
    var frequency : Float = 1       //the ordinary frequency, the number of oscillations (cycles) that occurs per second
    var phase : Float = 0           //the phase, specifies (in radians) where in its cycle the oscillation is at t = 0.
    var w : Float!                  //Angular frequency =  2πf
    
    override init(shader: ShaderProgram)
    {
        super.init(shader: shader)
        
        //let mat = self.material as! GenericMaterial
        //mat.surfaceColor = Color(255/255,255/255,0/255,1) //yellow
        
        w = 2 * .pi * frequency
        
        let mat = GenericMaterial(shader)
        mat.surfaceColor = Color(0,1,0,1)
        
        let objLoader = ObjLoader()
        objLoader.Read(fileName: "grassHopper");
        let ro = RenderObject(fromShader:shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        self.renderObject = ro
        self.material = mat
        
        self.setScale(0.2)
        self.rotationOffset = 180
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = HoppingMinion(shader: shader)
        copy.health = self.health
        copy.speed = self.speed
        return copy
    }
    
    override func update(dt: TimeInterval) {
        super.update(dt: dt)
        timeElapsed += Float(dt)
        self.y = 0.5 + amplitude * abs(sin(0.5 * w * timeElapsed + phase))
        
    }
}
