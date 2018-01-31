/*
#include "PlayState.h"
#include <SFML/Graphics/Color.hpp>
#include <SFML/Graphics/RenderWindow.hpp>

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
