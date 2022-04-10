package kata

type grid struct {
	width  int
	height int
}

func newGrid(width, height int) grid {
	return grid{
		width:  width,
		height: height,
	}
}
