package kata

func moveExecutor(grid grid) commandExecutorFunc {
	return func(p position) position {
		switch p.direction {
		case E:
			p.x++
			if p.x >= grid.width {
				p.x = 0
			}
		case W:
			p.x--
			if p.x < 0 {
				p.x = grid.width - 1
			}
		case N:
			p.y++
			if p.y >= grid.height {
				p.y = 0
			}
		case S:
			p.y--
			if p.y < 0 {
				p.y = grid.height - 1
			}
		}
		return p
	}
}
