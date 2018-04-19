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
            DispatchQueue.main.async {

                // weird hacky fix where we need to double async to make sure screen is updated before executing PlayState intiailization
                
                // from what I understand a screen update is NOT guaranteed after a main update, BUT is after an async update. This is why it doesn't matter if screen is hidden in main or async, as long as PlayState is nested in an async.
                
                self.viewController.loadingScreen.isHidden = false
                
                DispatchQueue.main.async {
                    self.next = PlayState(replacing: false, viewController: self.viewController)
                    
                    self.viewController.loadingScreen.isHidden = true
                }
            }
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
        next = nil
    }
    
}
