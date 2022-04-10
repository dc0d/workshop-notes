package kata

type direction rune

func newDirection() direction {
	return N
}

func (d direction) left() direction {
	return lefts[d]
}

func (d direction) right() direction {
	return rights[d]
}

func (d direction) String() string {
	return string(d)
}

var (
	lefts = map[direction]direction{
		N: W,
		E: N,
		S: E,
		W: S,
	}

	rights = map[direction]direction{
		N: E,
		E: S,
		S: W,
		W: N,
	}
)

const (
	N direction = 'N'
	E direction = 'E'
	S direction = 'S'
	W direction = 'W'
)
