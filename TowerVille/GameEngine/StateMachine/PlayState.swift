import Foundation

class PlayState : State {
    
    var map : Map = Map()
    let shader : ShaderProgram = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    let spawner : MinionSpawner
    
   
    
    override init(replacing : Bool = true) {
        
        spawner = MinionSpawner(minion: Minion(shader: shader))
        super.init(replacing: replacing)
    }
    
    override func update(dt: TimeInterval) {
        spawner.update(dt: dt)
    }
    
    override func draw() {
        spawner.draw()
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
