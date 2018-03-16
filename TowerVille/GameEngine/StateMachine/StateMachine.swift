import Foundation

class StateMachine
{
    var resume : Bool = false
    var running : Bool = false
    var states : Stack<State> = Stack<State>();
 
    static let Instance : StateMachine = StateMachine()
    
    func nextState() {
        
        // Going back to last state 
        if (resume) {
            // Cleanup the current state
            let removing = states.pop()
            removing?.exit()
            
            // Resume previous state
            states.top?.resume();
            states.top?.enter();
            resume = false;
        }

        // There needs to be a state
        if let nextState = states.top?.next {
            
            // Replace the running state
            if (nextState.replacing) {
                let oldState = states.pop();
                oldState?.exit();
            }
            // Pause the running state
            else
            {
                states.top?.pause();
                states.top?.exit();
            }
            
            nextState.enter();
            states.push(nextState);
        }
    }

    func state() -> State? {
        return states.top
    }
    
    func run(state : State) {
        running = true;
        states.push(state);
    }

    func lastState() {
        resume = true;
    }

    func update(dt : TimeInterval) {
        states.top?.update(dt : dt)
    }

    func draw() {
        states.top?.draw()
    }
    
    func processInput(x : Float, z : Float, u : Float, v : Float) {
        states.top?.processInput(x: x, z : z, u : u, v : v)
    }
    
    func processUiAction(action : UIActionType)
    {
        states.top?.processUiInput(action: action)
    }

}
