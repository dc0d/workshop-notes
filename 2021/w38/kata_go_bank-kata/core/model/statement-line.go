package model

import "strconv"

type statementLine struct {
	TransactionRecord
}

func (obj statementLine) String() string {
	return obj.Date.Format(dateFormat) + " || " + strconv.Itoa(obj.SignedAmount())
}

func (obj statementLine) SignedAmount() int {
	amount := signedAmount(obj.Amount, obj.TransactionType)
	return amount
}

func signedAmount(in Amount, txtype TransactionType) int {
	amount := int(in)
	if txtype == Withdrawal {
		amount *= -1
	}
	return amount
}

const (
	dateFormat = "02/01/2006"
)
