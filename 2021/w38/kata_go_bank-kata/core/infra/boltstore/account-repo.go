package boltstore

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"kata/core/model"

	bolt "go.etcd.io/bbolt"
)

type AccountRepo struct {
	db *bolt.DB
}

func NewAccountRepo(db *bolt.DB) *AccountRepo {
	res := &AccountRepo{
		db: db,
	}

	return res
}

func (obj *AccountRepo) Save(transaction model.TransactionRecord) error {
	return obj.db.Update(func(tx *bolt.Tx) error {
		bk, err := tx.CreateBucketIfNotExists([]byte(TransactionBucket))
		if err != nil {
			return err
		}

		version, err := latestTransactionVersion(bk, []byte(transaction.ClientID))
		if err != nil {
			return err
		}

		k := key{ID: string(transaction.ClientID), Version: version}
		return putJS(bk, k.String(), transaction)
	})
}

func (obj *AccountRepo) Load(clientID model.ClientID) (res []model.TransactionRecord, resErr error) {
	resErr = obj.db.View(func(tx *bolt.Tx) error {
		bk := tx.Bucket([]byte(TransactionBucket))
		if bk == nil {
			return bolt.ErrBucketNotFound
		}
		c := bk.Cursor()
		prefixClientID := []byte(clientID)
		for k, v := c.Seek(prefixClientID); k != nil && bytes.HasPrefix(k, prefixClientID); k, v = c.Next() {
			cpv := append([]byte(nil), v...)

			var rec model.TransactionRecord
			err := json.Unmarshal(cpv, &rec)
			if err != nil {
				return err
			}

			res = append(res, rec)
		}

		return nil
	})

	return
}

const (
	TransactionBucket = "transactions"
)

type key struct {
	ID      string
	Version int
}

func (obj key) String() string { return fmt.Sprintf("%s:%010d", obj.ID, obj.Version) }

func putJS(bk *bolt.Bucket, key string, val interface{}) error {
	js, err := json.Marshal(val)
	if err != nil {
		return err
	}
	return bk.Put([]byte(key), js)
}

func latestTransactionVersion(bk *bolt.Bucket, prefixClientID []byte) (version int, resErr error) {
	version = 1
	lastKey := lastTransactionKeyFor(bk, prefixClientID)
	if len(lastKey) > 0 {
		parts := strings.Split(string(lastKey), ":")
		const (
			base    = 10
			bitSize = 64
		)
		n, err := strconv.ParseInt(parts[1], base, bitSize)
		if err != nil {
			return 0, err
		}
		version = int(n) + 1
	}

	return
}

func lastTransactionKeyFor(bk *bolt.Bucket, prefixClientID []byte) (lastKey []byte) {
	c := bk.Cursor()
	for k, v := c.Seek(prefixClientID); k != nil && bytes.HasPrefix(k, prefixClientID); k, v = c.Next() {
		_ = v
		lastKey = k
	}
	return
}
