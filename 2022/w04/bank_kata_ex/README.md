# Bank Kata

> [kata description](https://github.com/sandromancuso/Bank-kata)

Application structure
- Adapters/Delivery: `lib/bank/delivery/`
  - Web API Adapter: `lib/bank/delivery/webapi/`
- Core Ports/Actions/Interactors:`lib/bank/core/actions/`
  - Deposit Action: `lib/bank/core/actions/deposit.ex`
  - Withdraw Action: `lib/bank/core/actions/withdraw.ex`
  - Print Statement Action: `lib/bank/core/actions/print_statement.ex`
- Core Model: `lib/bank/core/model/`
  - Account Service: `lib/bank/core/model/account-service.ex`

Adapters trigger Ports, which in turn trigger use-cases in a core service.

```
Adapter -> Port/Action Protocol/Interface
           Port/Action Implementation -> Service Protocol/Interface
                                         Service Implementation -> Repo Protocol/Interface
                                                                   Repo Implementation -> Driven Infrastructure
```


# Bank

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bank_kata_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bank_kata_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bank_kata_ex>.

