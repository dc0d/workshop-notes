//go:generate moq -out account_repo_spy.go . AccountRepo:AccountRepoSpy

package modeltest

import "kata/core/model"

type (
	AccountRepo = model.AccountRepo
)
