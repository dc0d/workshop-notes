package kata

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestRoverTestSuite(t *testing.T) {
	suite.Run(t, new(roverTestSuite))
}

type roverTestSuite struct {
	suite.Suite
}

func (s *roverTestSuite) Test_should_be_at_0_0_N_initially() {
	sut := newRover()
	expectedPosition := newPosition(location{x: 0, y: 0}, N)

	actualPosition := sut.currentPosition()

	s.Equal(expectedPosition, actualPosition)
}

func (s *roverTestSuite) Test_should_change_direction_on_command_L() {
	sut := newRover()
	expectedPosition := newPosition(location{x: 0, y: 0}, W)

	sut.executeCommand(L)
	actualPosition := sut.currentPosition()

	s.Equal(expectedPosition, actualPosition)
}

func (s *roverTestSuite) Test_should_change_direction_on_command_R() {
	sut := newRover()
	expectedPosition := newPosition(location{x: 0, y: 0}, E)

	sut.executeCommand(R)
	actualPosition := sut.currentPosition()

	s.Equal(expectedPosition, actualPosition)
}

func (s *roverTestSuite) Test_should_be_at_expected_position_adter_executing_a_command_sequence() {
	testCases := []struct {
		given []command
		then  position
	}{
		{[]command{R, M, M, L, M}, newPosition(location{x: 2, y: 1}, N)},
		{[]command{L, M, L, M, L, M, L, M}, newPosition(location{x: 0, y: 0}, N)},
		{[]command{L, M, L, M, L, M, L, M, L, M}, newPosition(location{x: 9, y: 0}, W)},
	}

	for _, testCase := range testCases {
		sut := newRover()

		sut.executeCommands(testCase.given...)

		actualPosition := sut.currentPosition()
		s.Equal(testCase.then, actualPosition)
	}
}
