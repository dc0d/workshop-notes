package kata

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestCommandTestSuite(t *testing.T) {
	suite.Run(t, new(CommandTestSuite))
}

type CommandTestSuite struct {
	suite.Suite
}

func (s *CommandTestSuite) Test_should_be_None_initially() {
	var sut command

	s.Equal(None, sut)
}

func (s *CommandTestSuite) Test_String() {
	testCases := []struct {
		given command
		then  string
	}{
		{None, "None"},
		{L, "L"},
		{R, "R"},
		{M, "M"},
	}

	for _, testCase := range testCases {
		actual := fmt.Sprint(testCase.given)

		s.Equal(testCase.then, actual)
	}
}
