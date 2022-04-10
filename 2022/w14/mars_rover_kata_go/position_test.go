package kata

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestPositionTestSuite(t *testing.T) {
	suite.Run(t, new(positionTestSuite))
}

type positionTestSuite struct {
	suite.Suite
}

func (s *positionTestSuite) Test_should_give_updated_position_when_turning_left() {
	testCases := []struct {
		given position
		then  position
	}{
		{position{location{0, 0}, N}, position{location{0, 0}, W}},
		{position{location{0, 0}, W}, position{location{0, 0}, S}},
		{position{location{0, 0}, S}, position{location{0, 0}, E}},
		{position{location{0, 0}, E}, position{location{0, 0}, N}},
	}

	for _, testCase := range testCases {
		actual := testCase.given.turnLeft()

		s.Equal(testCase.then, actual)
	}
}

func (s *positionTestSuite) Test_should_give_updated_position_when_turning_right() {
	testCases := []struct {
		given position
		then  position
	}{
		{position{location{0, 0}, N}, position{location{0, 0}, E}},
		{position{location{0, 0}, E}, position{location{0, 0}, S}},
		{position{location{0, 0}, S}, position{location{0, 0}, W}},
		{position{location{0, 0}, W}, position{location{0, 0}, N}},
	}

	for _, testCase := range testCases {
		actual := testCase.given.turnRight()

		s.Equal(testCase.then, actual)
	}
}

func (s *positionTestSuite) Test_String() {
	testCases := []struct {
		given position
		then  string
	}{
		{position{location{0, 0}, N}, "0:0:N"},
		{position{location{5, 5}, W}, "5:5:W"},
	}

	for _, testCase := range testCases {
		actual := fmt.Sprint(testCase.given)

		s.Equal(testCase.then, actual)
	}
}
