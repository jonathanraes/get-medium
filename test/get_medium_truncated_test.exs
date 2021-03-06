defmodule GetMediumTruncatedTest do
  use ExUnit.Case

  test "returns a list of parsed, truncated blog posts" do
    posts = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}"
            |> GetMedium.Truncated.blog_posts()

    assert is_list(posts)
  end

  test "returns a list with three blog posts" do
    posts = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}&count=3"
            |> GetMedium.Truncated.blog_posts()

    assert Enum.count(posts) == 3
  end

  test "allows access to post information" do
    [first, _second, _third] = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}&count=3"
                              |> GetMedium.Truncated.blog_posts()

    assert first.title != ""
  end

  test "posts can be returned with raw HTML for the content" do
    posts = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=#{System.get_env("RSS2JSON")}"
            |> GetMedium.Truncated.blog_posts(raw: true)
    post = hd(posts)

    assert String.contains?(post.content, "<p>")
  end
end
