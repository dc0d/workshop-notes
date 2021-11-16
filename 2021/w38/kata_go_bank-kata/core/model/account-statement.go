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
	lines := makeLines(obj.records)
	reverse(lines)

	return "Date       || Amount || Balance\n" +
		strings.Join(lines, "\n") +
		"\n"
}

func makeLines(records []statementLine) (lines []string) {
	var balance int
	for _, rec := range records {
		amount := rec.SignedAmount()
		balance += amount
		lines = append(lines, rec.String()+"   || "+fmt.Sprint(balance))
	}
	return
}

func reverse(lines []string) {
	for left, right := 0, len(lines)-1; left < right; left, right = left+1, right-1 {
		lines[left], lines[right] = lines[right], lines[left]
	}
}
