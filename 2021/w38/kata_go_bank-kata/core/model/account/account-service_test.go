package account

import (
	"errors"
	"testing"
	"time"

	"kata/core/model"
	"kata/core/model/modeltest"

	"github.com/rs/xid"
	"github.com/stretchr/testify/suite"
)

func Test_AccountService(t *testing.T) {
	suite.Run(t, new(testSuiteAccountService))
}

type testSuiteAccountService struct {
	suite.Suite

	clientID model.ClientID
	amount   model.Amount
	date     time.Time

	repo *modeltest.AccountRepoSpy
	sut  *AccountService
}

func (obj *testSuiteAccountService) SetupTest() {
	obj.clientID = model.ClientID(xid.New().String())
	obj.amount = 1000
	obj.date = date(2018, time.January, 19)
	obj.repo = &modeltest.AccountRepoSpy{}
	obj.sut = NewAccountService(obj.repo)
}

func (obj *testSuiteAccountService) Test_default_TimeSource_should_return_utc_time() {
	t := obj.sut.TimeSource()
	obj.Equal(time.UTC, t.Location())
}

//nolint:dupl
func (obj *testSuiteAccountService) Test_Deposit_should_call_repo_properly() {
	obj.repo.SaveFunc = func(transaction model.TransactionRecord) error { return nil }
	obj.sut.TimeSource = func() time.Time { return obj.date }

	err := obj.sut.Deposit(obj.clientID, obj.amount)
	obj.NoError(err)

	// verify state at boundary - mindset
	expectedRecord := model.TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: model.Deposit,
		Amount:          obj.amount,
		Date:            obj.date,
	}
	obj.EqualValues(expectedRecord, obj.repo.SaveCalls()[0].Transaction)
}

func (obj *testSuiteAccountService) Test_Deposit_should_return_repo_error() {
	expectedError := errors.New("some error")
	obj.repo.SaveFunc = func(transaction model.TransactionRecord) error { return expectedError }
	obj.sut.TimeSource = func() time.Time { return obj.date }

	actualErr := obj.sut.Deposit(obj.clientID, obj.amount)
	obj.Equal(expectedError, actualErr)
}

//nolint:dupl
func (obj *testSuiteAccountService) Test_Withdrawal_should_call_repo_properly() {
	obj.repo.SaveFunc = func(transaction model.TransactionRecord) error { return nil }
	obj.sut.TimeSource = func() time.Time { return obj.date }

	err := obj.sut.Withdrawal(obj.clientID, obj.amount)
	obj.NoError(err)

	// verify state at boundary - mindset
	expectedRecord := model.TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: model.Withdrawal,
		Amount:          obj.amount,
		Date:            obj.date,
	}
	obj.EqualValues(expectedRecord, obj.repo.SaveCalls()[0].Transaction)
}

func (obj *testSuiteAccountService) Test_Withdrawal_should_return_repo_error() {
	expectedError := errors.New("some error")
	obj.repo.SaveFunc = func(transaction model.TransactionRecord) error { return expectedError }
	obj.sut.TimeSource = func() time.Time { return obj.date }

	actualErr := obj.sut.Withdrawal(obj.clientID, obj.amount)
	obj.Equal(expectedError, actualErr)
}

func (obj *testSuiteAccountService) Test_PrintStatement_should_call_repo_properly() {
	obj.repo.LoadFunc = func(clientID model.ClientID) (res []model.TransactionRecord, resErr error) {
		res = append(res,
			model.TransactionRecord{
				ClientID:        obj.clientID,
				TransactionType: model.Deposit,
				Amount:          1000,
				Date:            date(2012, time.January, 10),
			},
			model.TransactionRecord{
				ClientID:        obj.clientID,
				TransactionType: model.Deposit,
				Amount:          2000,
				Date:            date(2012, time.January, 13),
			},
			model.TransactionRecord{
				ClientID:        obj.clientID,
				TransactionType: model.Withdrawal,
				Amount:          500,
				Date:            date(2012, time.January, 14),
			},
		)
		return
	}

	st, err := obj.sut.PrintStatement(obj.clientID)
	obj.NoError(err)

	obj.EqualValues(obj.clientID, obj.repo.LoadCalls()[0].ClientID)

	expectedStatement :=
		"Date       || Amount || Balance\n" +
			"14/01/2012 || -500   || 2500\n" +
			"13/01/2012 || 2000   || 3000\n" +
			"10/01/2012 || 1000   || 1000\n"
	obj.Equal(expectedStatement, st.String())
}

func (obj *testSuiteAccountService) Test_PrintStatement_should_return_repo_error() {
	expectedError := errors.New("some error")
	obj.repo.LoadFunc = func(clientID model.ClientID) ([]model.TransactionRecord, error) { return nil, expectedError }

	_, actualErr := obj.sut.PrintStatement(obj.clientID)

	obj.Equal(expectedError, actualErr)
}

//nolint:unparam
func date(year int, month time.Month, day int) time.Time {
	return time.Date(year, month, day, 0, 0, 0, 0, time.UTC)
}
