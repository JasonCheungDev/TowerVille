import Foundation

class PlayState : State {
    
    let shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    
    let tower : Tower
    
    override init(machine : StateMachine, replacing : Bool = true) {
        tower = Tower(10.0, 10.0, shader:shader)
        super.init(machine : machine, replacing: replacing)
        
    }
    
    override func update(dt: TimeInterval) {
        //_next = IntroState(machine : _machine)
    }
    
    override func draw() {
        tower.Draw()
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
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
