defmodule Monad.Mixfile do
  use Mix.Project

  def project do
    [app: :monadex,
     version: "1.0.0",
     elixir: "~> 1.0",
     name: "MonadEx",
     source_url: "https://github.com/rob-brown/MonadEx",
     homepage_url: "https://github.com/rob-brown/MonadEx",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
    ]
  end
end
