package boltstore

import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"testing"
	"time"

	"kata/core/model"
	"kata/tests/support"

	"github.com/rs/xid"
	"github.com/stretchr/testify/suite"
	bolt "go.etcd.io/bbolt"
)

var (
	repo *AccountRepo
	_    model.AccountRepo = repo
)

func Test_AccountRepo(t *testing.T) {
	suite.Run(t, new(testSuiteAccountRepo))
}

type testSuiteAccountRepo struct {
	suite.Suite

	db          *bolt.DB
	clientID    model.ClientID
	transaction model.TransactionRecord
	sampleList1 []model.TransactionRecord

	sut *AccountRepo
}

func (obj *testSuiteAccountRepo) SetupSuite() {
	if !support.RunIntegrationTest() {
		obj.T().SkipNow()
	}
}

func (obj *testSuiteAccountRepo) SetupTest() {
	obj.clientID = model.ClientID(xid.New().String())
	obj.transaction = model.TransactionRecord{
		ClientID:        obj.clientID,
		TransactionType: model.Deposit,
		Amount:          1000,
		Date:            time.Date(2018, time.November, 19, 0, 0, 0, 0, time.UTC),
	}
	obj.sampleList1 = []model.TransactionRecord{
		{
			ClientID:        obj.clientID,
			TransactionType: model.Deposit,
			Amount:          1000,
			Date:            time.Date(2018, time.November, 19, 0, 0, 0, 0, time.UTC),
		},
		{
			ClientID:        obj.clientID,
			TransactionType: model.Deposit,
			Amount:          2000,
			Date:            time.Date(2018, time.November, 19, 9, 0, 0, 0, time.UTC),
		},
		{
			ClientID:        obj.clientID,
			TransactionType: model.Deposit,
			Amount:          1000,
			Date:            time.Date(2018, time.November, 19, 18, 0, 0, 0, time.UTC),
		},
	}

	dbpath := filepath.Join(os.TempDir(), xid.New().String())
	var err error
	const rw = 0600
	obj.db, err = bolt.Open(dbpath, rw, nil)
	if err != nil {
		obj.T().Fatal(err)
	}
	obj.sut = NewAccountRepo(obj.db)
}

func (obj *testSuiteAccountRepo) TearDownTest() {
	err := obj.db.Close()
	obj.NoError(err)
}

func (obj *testSuiteAccountRepo) Test_Save_saves_the_transaction() {
	err := obj.sut.Save(obj.transaction)
	obj.NoError(err)

	k := key{ID: string(obj.transaction.ClientID), Version: 1}
	var rec model.TransactionRecord
	err = obj.db.View(func(tx *bolt.Tx) error {
		bk := tx.Bucket([]byte(TransactionBucket))
		if bk == nil {
			return bolt.ErrBucketNotFound
		}
		data := bk.Get([]byte(k.String()))
		if data == nil {
			return errors.New("data not found")
		}
		jsErr := json.Unmarshal(data, &rec)
		if jsErr != nil {
			return jsErr
		}
		return nil
	})
	obj.NoError(err)
	obj.EqualValues(obj.transaction, rec)
}

func (obj *testSuiteAccountRepo) Test_Save_saves_the_transactions_in_order() {
	txList := obj.sampleList1

	for _, tx := range txList {
		err := obj.sut.Save(tx)
		obj.NoError(err)
	}

	for i, tx := range txList {
		version := i + 1
		k := key{ID: string(tx.ClientID), Version: version}
		var rec model.TransactionRecord
		err := obj.db.View(func(tx *bolt.Tx) error {
			bk := tx.Bucket([]byte(TransactionBucket))
			if bk == nil {
				return bolt.ErrBucketNotFound
			}
			data := bk.Get([]byte(k.String()))
			if data == nil {
				return errors.New("data not found")
			}
			jsErr := json.Unmarshal(data, &rec)
			if jsErr != nil {
				return jsErr
			}
			return nil
		})
		obj.NoError(err)
		obj.EqualValues(tx, rec)
	}
}

func (obj *testSuiteAccountRepo) Test_Load_fetches_all_transactions_for_a_client() {
	txList := obj.sampleList1

	for _, tx := range txList {
		err := obj.sut.Save(tx)
		obj.NoError(err)
	}

	found, err := obj.sut.Load(obj.clientID)
	obj.NoError(err)
	obj.ElementsMatch(txList, found)
}
