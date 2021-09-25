package model

import (
	"testing"
	"time"

	"github.com/rs/xid"
	"github.com/stretchr/testify/suite"
)

func Test_statementLine(t *testing.T) {
	suite.Run(t, new(testSuiteStatementLine))
}

type testSuiteStatementLine struct {
	suite.Suite

	clientID        ClientID
	inputs          []TransactionRecord
	expectedTexts   []string
	expectedAmounts []int
}

func (obj *testSuiteStatementLine) SetupTest() {
	obj.clientID = ClientID(xid.New().String())

	obj.inputs = append(obj.inputs, TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: Deposit,
		Amount:          1000,
		Date:            time.Date(2018, time.January, 19, 0, 0, 0, 0, time.UTC),
	})
	obj.expectedTexts = append(obj.expectedTexts, "19/01/2018 || 1000")
	obj.expectedAmounts = append(obj.expectedAmounts, 1000)

	obj.inputs = append(obj.inputs, TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: Deposit,
		Amount:          1000,
		Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
	})
	obj.expectedTexts = append(obj.expectedTexts, "21/01/2018 || 1000")
	obj.expectedAmounts = append(obj.expectedAmounts, 1000)

	obj.inputs = append(obj.inputs, TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: Deposit,
		Amount:          2000,
		Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
	})
	obj.expectedTexts = append(obj.expectedTexts, "21/01/2018 || 2000")
	obj.expectedAmounts = append(obj.expectedAmounts, 2000)

	obj.inputs = append(obj.inputs, TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: Withdrawal,
		Amount:          500,
		Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
	})
	obj.expectedTexts = append(obj.expectedTexts, "21/01/2018 || -500")
	obj.expectedAmounts = append(obj.expectedAmounts, -500)
}

func (obj *testSuiteStatementLine) Test_String() {
	for i, tx := range obj.inputs {
		sut := statementLine{tx}
		obj.Equal(obj.expectedTexts[i], sut.String())
	}
}

func (obj *testSuiteStatementLine) Test_SignedAmount() {
	for i, tx := range obj.inputs {
		sut := statementLine{tx}
		obj.Equal(obj.expectedAmounts[i], sut.SignedAmount())
	}
}
