package model

import "time"

type AccountRepo interface {
	Save(transaction TransactionRecord) error
	Load(clientID ClientID) ([]TransactionRecord, error)
}

type TransactionRecord struct {
	ClientID        ClientID
	TransactionType TransactionType
	Amount          Amount
	Date            time.Time
}

const (
	Deposit    TransactionType = "deposit"
	Withdrawal TransactionType = "withdrawal"
)

type (
	ClientID        string
	TransactionType string
)
