package kata

func commandExecutorFactory(cmd command, grid grid) commandExecutor {
	switch cmd {
	case L:
		return commandExecutorFunc(turnLeftExecutor)
	case R:
		return commandExecutorFunc(turnRightExecutor)
	case M:
		return moveExecutor(grid)
	default:
		return commandExecutorFunc(noOpExecutor)
	}
}

func turnLeftExecutor(p position) position { return p.turnLeft() }

func turnRightExecutor(p position) position { return p.turnRight() }

func noOpExecutor(p position) position { return p }

type commandExecutorFunc func(position) position

func (f commandExecutorFunc) changePosition(p position) position { return f(p) }

type commandExecutor interface {
	changePosition(position) position
}
