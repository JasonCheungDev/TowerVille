import Foundation

class IntroState : State {
    
    override init(replacing : Bool = true, viewController : ViewController) {
        super.init(replacing: replacing, viewController: viewController)
        print("intro")
    }
    
    override func update(dt: TimeInterval) {
        // next = PlayState()
    }
    
    override func draw() {
        
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func processUiInput(action: UIActionType) {
        if (action == .PlaySelected)
        {
            next = PlayState(viewController: self.viewController)
        }
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
    override func enter() {
        self.viewController.showScreen(screenType: UIScreens.IntroScreen)
    }
    
    override func exit() {
        self.viewController.hideScreen(screenType: UIScreens.IntroScreen)
    }
    
}
