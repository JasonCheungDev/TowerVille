import Foundation

class StateMachine
{
    var resume : Bool = false
    var running : Bool = false
    var states : Stack<State> = Stack<State>();
 
    static let Instance : StateMachine = StateMachine()
    
    func nextState() {
        if (resume) {
            // Cleanup the current state
            _ = states.pop()

            // Resume previous state
            states.top?.resume();
            resume = false;
        }

        // There needs to be a state
        if let temp = states.top?.next {
            // Replace the running state
            if (temp.replacing) {
                _ = states.pop();
            }
            // Pause the running state
            else {
                states.top?.pause();
            }
            states.push(temp);
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

}
