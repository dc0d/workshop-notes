import Config

config :bank_kata_ex,
  actions: %{
    deposit: Bank.Core.Actions.Boundaries.MockDepositAction,
    withdraw: Bank.Core.Actions.Boundaries.MockWithdrawAction,
    print_statement: Bank.Core.Actions.Boundaries.MockPrintStatementAction
  },
  services: %{
    account: Bank.Core.Model.Account.MockService,
    time: Bank.Core.Model.Boundaries.MockTimeSource
  },
  repos: %{
    account: Bank.Boundaries.MockAccountRepo
  }
