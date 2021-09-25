package account

import (
	"time"

	"kata/core/model"
)

type AccountService struct {
	repo model.AccountRepo

	TimeSource func() time.Time
}

func NewAccountService(repo model.AccountRepo) *AccountService {
	res := &AccountService{
		repo:       repo,
		TimeSource: func() time.Time { return time.Now().UTC() },
	}

	return res
}

func (obj *AccountService) Deposit(clientID model.ClientID, amount model.Amount) error {
	return obj.repo.Save(model.TransactionRecord{
		ClientID:        clientID,
		TransactionType: model.Deposit,
		Amount:          amount,
		Date:            obj.TimeSource(),
	})
}

func (obj *AccountService) Withdrawal(clientID model.ClientID, amount model.Amount) error {
	return obj.repo.Save(model.TransactionRecord{
		ClientID:        clientID,
		TransactionType: model.Withdrawal,
		Amount:          amount,
		Date:            obj.TimeSource()})
}

func (obj *AccountService) PrintStatement(clientID model.ClientID) (*model.Statement, error) {
	records, err := obj.repo.Load(clientID)
	if err != nil {
		return nil, err
	}

	return model.NewStatement(records), nil
}
