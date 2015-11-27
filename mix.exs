defmodule Monad.Mixfile do
  use Mix.Project

  def project do
    [
      app: :monadex,
      version: "1.0.2",
      elixir: "~> 1.0",
      name: "MonadEx",
      source_url: "https://github.com/rob-brown/MonadEx",
      homepage_url: "https://github.com/rob-brown/MonadEx",
      deps: deps,
      description: description,
      package: package,
   ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
    ]
  end

  defp description do
    """
    Improve pipelines with monads.
    """
  end

  defp package do
    [
      maintainers: ["Robert Brown"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/rob-brown/MonadEx"},
    ]
  end
end
