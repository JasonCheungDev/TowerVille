import Foundation

class State
{
    var _next : State? = nil
    var _replacing : Bool = true
    var _machine : StateMachine
    
    init(machine : StateMachine, replacing : Bool = true) {
        _machine = machine
        _replacing = replacing
    }
    
    func update(dt : TimeInterval) {
        
    }
    
    func draw() {
        
    }
    
    func resume() {
        
    }
    
    func pause() {
        
    }
    
    func next() -> State? {
        return _next
    }
    
    func isReplacing() -> Bool {
        return _replacing
    }
    
/*
 public:
	State(StateMachine& machine, sf::RenderWindow& window, bool replace = true)
	: _machine(machine)
	, _window(window)
	, _replacing(replace)
	{
	}
	virtual ~State() = default;
	virtual void pause() = 0;
	virtual void resume() = 0;

	virtual void update(const sf::Time&) = 0;
	virtual void draw()const = 0;

	auto next() { return std::move(_next); }
	auto isReplacing() { return _replacing; }

protected:
	EventMap _events;
	sf::Event _event;
	StateMachine& _machine;
	sf::RenderWindow& _window;
	bool _replacing;
	std::unique_ptr<State> _next;
 */
}
