import Foundation

class IntroState : State {
    
    override init(replacing : Bool = true) {
        super.init(replacing : replacing)
        print("intro")
    }
    
    override func update(dt: TimeInterval) {
        next = PlayState()
    }
    
    override func draw() {
        
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}
