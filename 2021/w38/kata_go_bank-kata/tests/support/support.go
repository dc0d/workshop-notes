package support

import (
	"os"
	"strings"
)

func RunAcceptanceTest() bool {
	return isTestFlagPresent(getTestFlags(), acceptanceFlag)
}

func RunIntegrationTest() bool {
	return isTestFlagPresent(getTestFlags(), integrationFlag)
}

func getTestFlags() string {
	testFlags := os.Getenv(testFlagsEnvVarName)
	return testFlags
}

func isTestFlagPresent(testFlags, flag string) bool {
	return strings.Contains(testFlags, flag)
}

const (
	acceptanceFlag      = "acceptance"
	integrationFlag     = "integration"
	testFlagsEnvVarName = "RUN_TESTS"
)
