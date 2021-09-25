package model

import (
	"fmt"
	"strings"
)

type Statement struct {
	records []statementLine
}

func NewStatement(records []TransactionRecord) *Statement {
	res := &Statement{}

	for _, rec := range records {
		res.records = append(res.records, statementLine{rec})
	}

	return res
}

func (obj *Statement) String() string {
	var (
		lines   []string
		balance int
	)

	for _, rec := range obj.records {
		amount := rec.SignedAmount()
		balance += amount
		lines = append(lines, rec.String()+"   || "+fmt.Sprint(balance))
	}

	for left, right := 0, len(lines)-1; left < right; left, right = left+1, right-1 {
		lines[left], lines[right] = lines[right], lines[left]
	}

	return "Date       || Amount || Balance\n" +
		strings.Join(lines, "\n") +
		"\n"
}
