package kata

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestCommandExecutorFactoryTestSuite(t *testing.T) {
	suite.Run(t, new(commandExecutorFactoryTestSuite))
}

type commandExecutorFactoryTestSuite struct {
	suite.Suite
}

func (s *commandExecutorFactoryTestSuite) Test_should_cteare_noOpExecutor_on_an_invalid_command() {
	var invalidCommand command = 'Z'
	sut := commandExecutorFactory(invalidCommand, grid{})
	initialPosition := newPosition(location{x: 0, y: 0}, W)
	expectedPosition := newPosition(location{x: 0, y: 0}, W)

	actualPosition := sut.changePosition(initialPosition)

	s.Equal(expectedPosition, actualPosition)
}
