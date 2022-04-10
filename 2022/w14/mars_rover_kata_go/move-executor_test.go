package kata

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestMoveExecutorTestSuite(t *testing.T) {
	suite.Run(t, new(moveExecutorTestSuite))
}

type moveExecutorTestSuite struct {
	suite.Suite

	g grid
}

func (s *moveExecutorTestSuite) SetupTest() {
	s.g = newGrid(10, 10)
}

func (s *moveExecutorTestSuite) Test_should_wrap_around_when_reaches_beyond_end_of_the_x_axis() {
	sut := moveExecutor(s.g)
	initialPosition := newPosition(location{x: 9, y: 0}, E)
	expectedPosition := newPosition(location{x: 0, y: 0}, E)

	actualPosition := sut.changePosition(initialPosition)

	s.Equal(expectedPosition, actualPosition)
}

func (s *moveExecutorTestSuite) Test_should_wrap_around_when_reaches_beyond_0_of_the_x_axis() {
	sut := moveExecutor(s.g)
	initialPosition := newPosition(location{x: 0, y: 0}, W)
	expectedPosition := newPosition(location{x: 9, y: 0}, W)

	actualPosition := sut.changePosition(initialPosition)

	s.Equal(expectedPosition, actualPosition)
}

func (s *moveExecutorTestSuite) Test_should_wrap_around_when_reaches_beyond_end_of_the_y_axis() {
	sut := moveExecutor(s.g)
	initialPosition := newPosition(location{x: 0, y: 9}, N)
	expectedPosition := newPosition(location{x: 0, y: 0}, N)

	actualPosition := sut.changePosition(initialPosition)

	s.Equal(expectedPosition, actualPosition)
}

func (s *moveExecutorTestSuite) Test_should_wrap_around_when_reaches_beyond_0_of_the_y_axis() {
	sut := moveExecutor(s.g)
	initialPosition := newPosition(location{x: 0, y: 0}, S)
	expectedPosition := newPosition(location{x: 0, y: 9}, S)

	actualPosition := sut.changePosition(initialPosition)

	s.Equal(expectedPosition, actualPosition)
}
