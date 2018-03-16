import Foundation

class State
{
    var next : State? = nil
    var replacing : Bool = true
    
    init(replacing : Bool = true) {
        self.replacing = replacing
    }
    
    func update(dt : TimeInterval) {
        
    }
    
    func draw() {
        
    }
    
    func processInput(x : Float, z : Float, u : Float, v : Float) {
        
    }
    
    func processUiInput(action : UIActionType) {
        
    }
    
    func resume() {
        
    }
    
    func pause() {
        
    }
    
}
