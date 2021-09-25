package model

import (
	"testing"
	"time"

	"github.com/rs/xid"
	"github.com/stretchr/testify/suite"
)

func Test_Statement(t *testing.T) {
	suite.Run(t, new(testSuiteStatement))
}

type testSuiteStatement struct {
	suite.Suite

	clientID ClientID
	inputs   []tc
}

func (obj *testSuiteStatement) SetupTest() {
	obj.clientID = ClientID(xid.New().String())

	obj.inputs = append(obj.inputs,
		tc{
			records: []TransactionRecord{
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 19, 0, 0, 0, 0, time.UTC),
				},
			},
			expectedText: "Date       || Amount || Balance\n" +
				"19/01/2018 || 1000   || 1000\n",
		},
		tc{
			records: []TransactionRecord{
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
				},
			},
			expectedText: "Date       || Amount || Balance\n" +
				"21/01/2018 || 1000   || 1000\n",
		},
		tc{
			records: []TransactionRecord{
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          2000,
					Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
				},
			},
			expectedText: "Date       || Amount || Balance\n" +
				"21/01/2018 || 2000   || 2000\n",
		},
		tc{
			records: []TransactionRecord{
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 19, 0, 0, 0, 0, time.UTC),
				},
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
				},
			},
			expectedText: "Date       || Amount || Balance\n" +
				"21/01/2018 || 1000   || 2000\n" +
				"19/01/2018 || 1000   || 1000\n",
		},
		tc{
			records: []TransactionRecord{
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 19, 0, 0, 0, 0, time.UTC),
				},
				{
					ClientID:        obj.clientID,
					TransactionType: Deposit,
					Amount:          1000,
					Date:            time.Date(2018, time.January, 21, 0, 0, 0, 0, time.UTC),
				},
				{
					ClientID:        obj.clientID,
					TransactionType: Withdrawal,
					Amount:          500,
					Date:            time.Date(2018, time.January, 22, 0, 0, 0, 0, time.UTC),
				},
			},
			expectedText: "Date       || Amount || Balance\n" +
				"22/01/2018 || -500   || 1500\n" +
				"21/01/2018 || 1000   || 2000\n" +
				"19/01/2018 || 1000   || 1000\n",
		},
	)
}

func (obj *testSuiteStatement) Test_String() {
	for _, tc := range obj.inputs {
		sut := NewStatement(tc.records)
		obj.Equal(tc.expectedText, sut.String())
	}
}

type tc struct {
	records      []TransactionRecord
	expectedText string
}
