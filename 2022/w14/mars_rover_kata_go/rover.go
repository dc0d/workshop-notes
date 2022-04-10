package kata

type rover struct {
	current position
}

func newRover() *rover {
	res := &rover{
		current: newPosition(location{x: 0, y: 0}, N),
	}

	return res
}

func (r *rover) currentPosition() position { return r.current }

func (r *rover) executeCommand(command command) {
	r.current = commandExecutorFactory(command, newGrid(10, 10)).changePosition(r.current)
}

func (r *rover) executeCommands(commands ...command) {
	for _, command := range commands {
		r.executeCommand(command)
	}
}
