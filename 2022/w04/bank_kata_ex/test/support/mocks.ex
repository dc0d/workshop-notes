Mox.defmock(Bank.Boundaries.MockAccountRepo,
  for: Bank.Core.Model.Account.Boundaries.Repo
)

Mox.defmock(Bank.Core.Model.Account.MockService,
  for: Bank.Core.Model.Account.Boundaries.Service
)

Mox.defmock(Bank.Core.Model.Boundaries.MockTimeSource,
  for: Bank.Core.Model.Boundaries.TimeSource
)

Mox.defmock(Bank.Core.Actions.Boundaries.MockDepositAction,
  for: Bank.Core.Actions.Boundaries.Action
)

Mox.defmock(Bank.Core.Actions.Boundaries.MockWithdrawAction,
  for: Bank.Core.Actions.Boundaries.Action
)

Mox.defmock(Bank.Core.Actions.Boundaries.MockPrintStatementAction,
  for: Bank.Core.Actions.Boundaries.Action
)
