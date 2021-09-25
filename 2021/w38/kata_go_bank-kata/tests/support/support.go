package support

import (
	"flag"

	_ "github.com/stretchr/testify/suite"
)

func RunAcceptanceTest() bool {
	if acceptance == nil {
		return false
	}

	return *acceptance
}

func RunIntegrationTest() bool {
	if integration == nil {
		return false
	}

	return *integration
}

var (
	acceptance  = flag.Bool("acceptance", false, "acceptance")
	integration = flag.Bool("integration", false, "integration")
)
