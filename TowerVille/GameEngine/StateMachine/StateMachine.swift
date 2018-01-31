import Foundation


class StateMachine
{
    var _resume : Bool = false
    var _running : Bool = false
    var _states : Stack<State> = Stack<State>();
 
func nextState()
{
	if (_resume)
	{
		// Cleanup the current state
		if (!_states.isEmpty)
		{
			_ = _states.pop();
		}

		// Resume previous state
		if (!_states.isEmpty)
		{
			_states.top?.resume();
		}

		_resume = false;
	}

	// There needs to be a state
	if (!_states.isEmpty)
	{
		if let temp = _states.top?.next()
        {

		// Only change states if there's a next one existing
		//if (temp != nil)
		//{
			// Replace the running state
            if (temp.isReplacing()) {
				_ = _states.pop();
            }
			// Pause the running state
            else {
				_states.top?.pause();
            }

			_states.push(temp);
		}
	}
}

    func run(state : State) {
        _running = true;
        _states.push(state);
    }

    func lastState() {
        _resume = true;
    }

    func update(dt : Float) {
        _states.top?.update(dt : dt)
    }

    func draw() {
        _states.top?.draw()
    }

    func running() -> Bool {
        return _running;
    }

    func quit() {
        _running = false;
    }

}
