defmodule GetMediumTruncatedTest do
  use ExUnit.Case

  test "returns a list of truncated blog posts" do
    posts = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}"
            |> GetMedium.Truncated.blog_posts(304)

    assert is_list(posts)
  end

  test "returns a list with three blog posts" do
    posts = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}&count=3"
            |> GetMedium.Truncated.blog_posts(304)

    assert Enum.count(posts) == 3
  end

  test "allows access to post information" do
    [first, _second, _third] = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}&count=3"
                              |> GetMedium.Truncated.blog_posts(304)

    assert first.title != ""
  end
end
