package tests

import (
	"os"
	"path/filepath"
	"testing"
	"time"

	"kata/core/infra/boltstore"
	"kata/core/model"
	"kata/core/model/account"
	"kata/tests/support"

	"github.com/rs/xid"
	"github.com/stretchr/testify/suite"
	bolt "go.etcd.io/bbolt"
)

func Test_AccountService(t *testing.T) {
	suite.Run(t, new(acceptanceSuiteAccountService))
}

type acceptanceSuiteAccountService struct {
	suite.Suite

	db       *bolt.DB
	clientID model.ClientID

	repo *boltstore.AccountRepo
	sut  *account.AccountService
}

func (obj *acceptanceSuiteAccountService) SetupSuite() {
	if !support.RunAcceptanceTest() {
		obj.T().SkipNow()
	}
}

func (obj *acceptanceSuiteAccountService) SetupTest() {
	obj.clientID = model.ClientID(xid.New().String())

	dbpath := filepath.Join(os.TempDir(), xid.New().String())
	var err error
	const rw = 0600
	obj.db, err = bolt.Open(dbpath, rw, nil)
	if err != nil {
		obj.T().Fatal(err)
	}
	obj.repo = boltstore.NewAccountRepo(obj.db)
	obj.sut = account.NewAccountService(obj.repo)
}

func (obj *acceptanceSuiteAccountService) TearDownTest() {
	err := obj.db.Close()
	obj.NoError(err)
}

func (obj *acceptanceSuiteAccountService) Test_desired_behavior() {
	times := []time.Time{
		date(2012, time.January, 10),
		date(2012, time.January, 13),
		date(2012, time.January, 14),
	}
	lastTime := 0
	obj.sut.TimeSource = func() time.Time {
		defer func() { lastTime++ }()
		return times[lastTime]
	}

	// Given a client makes a deposit of 1000 on 10-01-2012
	err := obj.sut.Deposit(obj.clientID, model.Amount(1000))
	obj.NoError(err)

	// And a deposit of 2000 on 13-01-2012
	err = obj.sut.Deposit(obj.clientID, model.Amount(2000))
	obj.NoError(err)

	// And a withdrawal of 500 on 14-01-2012
	err = obj.sut.Withdrawal(obj.clientID, model.Amount(500))
	obj.NoError(err)

	// When they print their bank statement
	statement, err := obj.sut.PrintStatement(obj.clientID)
	obj.NoError(err)

	// Then they would see:
	expectedStatement :=
		"Date       || Amount || Balance\n" +
			"14/01/2012 || -500   || 2500\n" +
			"13/01/2012 || 2000   || 3000\n" +
			"10/01/2012 || 1000   || 1000\n"
	obj.Equal(expectedStatement, statement.String())
}

func date(year int, month time.Month, day int) time.Time {
	return time.Date(year, month, day, 0, 0, 0, 0, time.UTC)
}
