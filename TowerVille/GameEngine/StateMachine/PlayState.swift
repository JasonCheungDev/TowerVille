import Foundation

class PlayState : State {
    
    static var map : Map = Map()
    let minion : Minion = Minion()
    
    override init(replacing : Bool = true) {
        super.init(replacing: replacing)
        print("play")
        
    }
    
    override func update(dt: TimeInterval) {
        //_next = IntroState(machine : _machine)
        minion.update(dt: dt)
    }
    
    override func draw() {
        minion.Draw()
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
