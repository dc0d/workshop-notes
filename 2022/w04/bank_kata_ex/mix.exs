defmodule Bank.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_kata_ex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      test_coverage: [
        summary: [threshold: 85],
        ignore_modules: [
          Bank.Application,
          Bank.Core.Model.Boundaries.MockTimeSource,
          Bank.Tests.Support.FakeAccountRepo
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bank.Application, []}
    ]
  end

  defp deps do
    [
      {:mox, "~> 1.0.1", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:uuid, "~> 1.1"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      compile: ["compile --warning-as-errors"],
      test: ["test --no-start"]
    ]
  end
end
