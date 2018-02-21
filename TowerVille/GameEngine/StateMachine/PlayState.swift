import Foundation

class PlayState : State {
    
    var map : Map = Map()
    let shader : ShaderProgram = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    let spawner : MinionSpawner
    var minions : [Minion] = []
    
   
    
    override init(replacing : Bool = true) {
        spawner = MinionSpawner(minion: Minion(shader: shader))
        super.init(replacing: replacing)
    }
    
    override func update(dt: TimeInterval) {
        spawner.update(dt: dt, minions: &minions)
        
        for guy in minions {
            print(minions.count)
            guy.update(dt: dt)
        }
        
    }
    
    override func draw() {
        
        for guy in minions {
            guy.draw()
        }
        
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
