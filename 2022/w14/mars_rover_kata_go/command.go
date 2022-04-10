package kata

type command rune

func (c command) String() string {
	if c == None {
		return "None"
	}
	return string(c)
}

const (
	None command = 0
	L    command = 'L'
	R    command = 'R'
	M    command = 'M'
)
