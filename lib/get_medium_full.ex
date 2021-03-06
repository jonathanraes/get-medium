defmodule GetMedium.Full do
  @moduledoc """
  This module returns a full version of your Medium blog posts with no truncating of the content. It requires your Medium RSS URL (see blog_posts/2 for details).
  """

  use Timex

  @doc """
  Using a URL created by RSS2JSON for your Medium blog, it returns a list of your blog posts. Other services to get JSON for your Medium feed might work but the structure could be different and may break the app.

  Publications have a feed format of https://medium.brianemorycom/feed and personal feeds have a format of https://medium.com/feed/@thebrianemory. Using the URL and https://rss2json.com, you will get a URL for an API call to return you feed in a JSON format. With RSS2JSON, you can use just your feed URL or you can register and use your API key to add more options like order by, order direction and items count.

  ### RSS2JSON feed examples
  Using an API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed&api_key=YOUR_API_KEY&count=3
  No API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed

  ## How it works
  Calling `GetMedium.Full.blog_posts(url)`, where `url` is the URL to the API call you got from RSS2JSON, `HTTPoison` and `Poison` are used to fetch and parse the JSON. This returns a list of your posts. By default, the content is returned with the HTML tags removed. You can changes this by passing `raw: true` as an argument.

  ## Examples
  A simple example of how it works. I am using my publications's RSS feed, I have registered with RSS2Json so I can use my API key to return only the last three of my blog posts.
      iex> use GetMedium
      ...> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
      ...> GetMedium.Full.blog_posts(url)
      [%{categories: ["programming", "coding", "elixir", "web-development"],
        content: "I was tasked with a code challenge to create an Elixir/Phoenix app that would be a newsletter sending system. The requirements were simple and I had 48 hours to complete it. I lost a bit of time on the first day which caused me to cut some corners and not use TDD (tsk tsk). I had a deadline and...",
        date: "Aug 11, 2017",
        link: ["https://medium.brianemory.com/a-newsletter-sending-system-code-challenge-22da00d073cc"],
        subheading: "Completing it taught me a lot",
        title: "A Newsletter Sending System Code Challenge"},
      %{categories: ["learning", "elixir", "programming", "goals", "web-development"],
        content: "I have been learning Elixir the last few months and I am really enjoying it. So much in fact, I am making that my main focus. This includes what I spend my time learning and programming, and where I apply to for jobs. Elixir 1.5 and Phoenix 1.3 just came out so it is a good time to buckle down and...",
        date: "Aug 02, 2017",
        link: ["https://medium.brianemory.com/focusing-on-programming-elixir-a77daab98c05"],
        subheading: "Time to change things up",
        title: "Focusing on Programming Elixir"},
      %{categories: ["programming", "elixir", "education", "phoenix", "web-development"],
        content: "I have been learning Elixir and Phoenix lately. This has entailed reading bits of books, reading blog posts, and following along with tutorials. It is time to build my first application that is not from a tutorial. I decided to make this easier on myself by cloning my Angular on Rails app ...",
        date: "May 19, 2017",
        link: ["https://medium.brianemory.com/elixir-phoenix-creating-an-app-part-1-the-setup-6626264be03"],
        subheading: "Learn by doing",
        title: "Elixir Phoenix: Creating An App (Part 1: The Setup)"}]

  You can also use pattern matching to easily access each post separately.
      iex> use GetMedium
      ...> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
      ...> [first, second, third] = GetMedium.Full.blog_posts(url)
      ...> first.title
      "A Newsletter Sending System Code Challenge"
  """

  @defaults %{raw: false}

  def blog_posts(url, options \\ []) do
    %{raw: raw} = Enum.into(options, @defaults)
    json_data = HTTPoison.get!(url)
    %{feed: _, items: items, status: _} = Poison.Parser.parse!(json_data.body, keys: :atoms)

    Enum.map(items, fn item ->
      post_data(item, raw)
    end)
  end

  def post_data(item, raw) do
    %{
      title: get_title(item.title),
      date: get_date(item.pubDate),
      link: get_link(item.link),
      thumbnail: get_thumbnail(item.thumbnail),
      subheading: get_subheading!(item.content),
      content: get_content(item.content, raw),
      categories: get_categories(item.categories)
    }
  end

  def get_title(title) do
    title
  end

  def get_date(date) do
    parsed_date = Timex.parse!(date, "%Y-%m-%d %H:%M:%S", :strftime)
    t_minus_1 = Timex.shift(Timex.to_naive_datetime(Timex.now()), days: -1)

    case Timex.before?(t_minus_1, parsed_date) do
      true ->
        Timex.from_now(parsed_date)

      false ->
        Timex.format!(parsed_date, "%b %d, %Y", :strftime)
    end
  end

  def get_link(link) do
    Regex.run(~r{[^?]+}, link)
  end

  def get_thumbnail(thumbnail) do
    thumbnail
  end

  def get_subheading!(content) do
    subheading =
      Regex.replace(~r{(<h4>|<h3>)}, content, "<Z>")
      |> (&Regex.replace(~r{(<\/h4>|<\/h3>)}, &1, "<Z>")).()
      |> (&Regex.replace(~r{(<a .*?href=['""](.+?)['""].*?>|</a>)}, &1, "")).()
      |> (&Regex.run(~r{<Z>(.*?)<Z>}, &1)).()

    case subheading do
      nil ->
        ""

      [_, subheading] ->
        subheading
    end
  end

  def get_content(content, raw) do
    case raw do
      true ->
        content

      false ->
        Regex.replace(~r{\n(<figure>).*(<\/figure>)}, content, "")
        |> (&Regex.replace(~r{(<h4>|<h3>).*(<\/h4>|<\/h3>)}, &1, "")).()
        |> (&Regex.replace(~r{(<a .*?href=['""](.+?)['""].*?>|</a>)}, &1, "")).()
        |> (&HtmlSanitizeEx.strip_tags(&1)).()
        |> (&Regex.replace(~r{(\n)}, &1, " ")).()
    end
  end

  def get_categories(categories) do
    categories
  end
end
