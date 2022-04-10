package kata

import "fmt"

type position struct {
	location
	direction direction
}

func newPosition(location location, direction direction) position {
	return position{location, direction}
}

func (p position) String() string {
	return fmt.Sprintf("%d:%d:%s", p.x, p.y, p.direction)
}

func (p position) turnLeft() position {
	return newPosition(p.location, p.direction.left())
}

func (p position) turnRight() position {
	return newPosition(p.location, p.direction.right())
}
