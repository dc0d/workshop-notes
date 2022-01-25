Application.ensure_all_started(:mox)
Application.ensure_all_started(:plug)

Bank.Tests.Support.FakeAccountRepo.start_link([])

ExUnit.start(trace: true, exclude: [:integration, :smoke])
