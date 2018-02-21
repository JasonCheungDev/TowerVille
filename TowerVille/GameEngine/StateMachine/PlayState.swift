import Foundation

class PlayState : State {
    
    var map : Map = Map()
    let shader : ShaderProgram = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    let minion : Minion
    
   
    
    override init(replacing : Bool = true) {
        minion = Minion(shader: shader)
        super.init(replacing: replacing)
    }
    
    override func update(dt: TimeInterval) {
        minion.update(dt: dt)
    }
    
    override func draw() {
        minion.draw()
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
