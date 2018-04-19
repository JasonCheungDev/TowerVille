import Foundation

class State
{
    var next : State? = nil
    var replacing : Bool = true
    var viewController : ViewController!
    
    init(replacing : Bool = true, viewController : ViewController) {
        self.replacing = replacing
        self.viewController = viewController
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
    
    // called when entering this state
    func enter()
    {
        
    }
    
    // called when leaving this state
    func exit()
    {
        
    }
    
    
}
