import Foundation

class PlayState : State {
    
    var map : Map = Map()
    let shader : ShaderProgram = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    let minion : Minion
    let tower : Tower
   
    
    
    override init(replacing : Bool = true) {
        minion = Minion(shader: shader)
        tower = Tower(8.0, -7.0, shader:shader)
        tower.setMinion(min: minion)
        super.init(replacing: replacing)

    }
    
    override func update(dt: TimeInterval) {
        minion.update(dt: dt)
        tower.update(dt: dt)
        
    }
    
    override func draw() {
        tower.draw()
        minion.draw()
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
