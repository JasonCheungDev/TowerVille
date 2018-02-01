import Foundation

class PlayState : State {
    
    override init(machine : StateMachine) {
        super.init(machine : machine)
        print("play")
    }
    
    override func update(dt: TimeInterval) {
        _next = IntroState(machine : _machine)
    }
    
    override func draw() {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}


/*
PlayState::PlayState(StateMachine& machine, sf::RenderWindow& window, bool replace)
	: State(machine, window, replace)
{
}

void PlayState::pause()
{
}

void PlayState::resume()
{
}

void PlayState::update(const sf::Time&)
{
	while (_window.pollEvent(_event))
	{
		_events.Invoke(_event);

	}
}

void PlayState::draw() const
{
	_window.clear(sf::Color::Black);

	_window.display();
}

PlayState::~PlayState()
{
}
*/
