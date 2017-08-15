# GetMedium

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `get_medium` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:get_medium, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/get_medium](https://hexdocs.pm/get_medium).

## test feeds
url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=w9ateic0eq7ntcvmixcn3yuet09w7x0acx6p0t67&count=3"
[first, second, third] = GetMedium.Truncated.blog_posts_truncated(url)


################# No heading ###############


url2 = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.freecodecamp.org%2Frss&api_key=w9ateic0eq7ntcvmixcn3yuet09w7x0acx6p0t67&count=3"
[first, second, third] = GetMedium.Truncated.blog_posts_truncated(url2)


################# No heading or image #################


url3 = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.com%2Ffeed%2F%40yonatanzunger%2F&api_key=w9ateic0eq7ntcvmixcn3yuet09w7x0acx6p0t67&count=3"
[first, second, third] = GetMedium.Truncated.blog_posts_truncated(url3)

#############

