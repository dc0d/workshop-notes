package kata

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestDirectionTestSuite(t *testing.T) {
	suite.Run(t, new(directionTestSuite))
}

type directionTestSuite struct {
	suite.Suite
}

func (s *directionTestSuite) Test_should_be_N_initially() {
	sut := newDirection()

	s.Equal(N, sut)
}

func (s *directionTestSuite) Test_should_provide_the_left_direction() {
	testCases := []struct {
		given direction
		then  direction
	}{
		{N, W},
		{E, N},
		{S, E},
		{W, S},
	}

	for _, testCase := range testCases {
		actual := testCase.given.left()

		s.Equal(testCase.then, actual)
	}
}

func (s *directionTestSuite) Test_should_provide_the_right_direction() {
	testCases := []struct {
		given direction
		then  direction
	}{
		{N, E},
		{E, S},
		{S, W},
		{W, N},
	}

	for _, testCase := range testCases {
		actual := testCase.given.right()

		s.Equal(testCase.then, actual)
	}
}

func (s *directionTestSuite) Test_String() {
	testCases := []struct {
		given direction
		then  string
	}{
		{N, "N"},
		{E, "E"},
		{S, "S"},
		{W, "W"},
	}

	for _, testCase := range testCases {
		sut := testCase.given
		expected := testCase.then

		actual := fmt.Sprint(sut)

		s.Equal(expected, actual)
	}
}
