defmodule GetMedium.Mixfile do
  use Mix.Project

  def project do
    [
      app: :get_medium,
      version: "0.4.0",
      elixir: "~> 1.5",
      description: "GetMedium returns a truncated version of your Medium blog posts.",
      source_url: "https://github.com/thebrianemory/get-medium",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      name: :get_medium,
      files: ["lib", "mix.exs"],
      maintainers: ["Brian Emory"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/thebrianemory/get-medium"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5.1"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"},
      {:html_sanitize_ex, "~> 1.3.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
