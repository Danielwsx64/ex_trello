defmodule ExTrello.MixProject do
  use Mix.Project

  @version "0.0.1"
  @description "A client library for Trello API"
  @links %{"GitHub" => "https://github.com/Danielwsx64/ex_trello"}

  def project do
    [
      app: :ex_trello,
      version: @version,
      description: @description,
      source_url: @links["GitHub"],
      package: package(),
      docs: docs(),
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      # Dev/Test dependencies
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: @links
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extra_section: "Guides",
      extras: ["README.md": [title: "Get starting"]]
    ]
  end
end
