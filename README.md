# GetMedium

GetMedium returns a truncated version of your Medium blog posts. It requires your Medium RSS URL (see `blog_posts_truncated/2` for details), and the number of characters to truncate at. The default value is set to 304 (305 characters when zero indexed). This will truncate your content at 305 characters, then trim that down passed the last space " ".

For example, if your post ends with "and that's the way the cookie crum", your content will be trimmed to end with "and that's the way the cookie". Even if the entire word "crumbles" was there, it would still do the same. This is to avoid ending up with partial words.

  For example, if your post ends with "and that's the way the cookie crum", your content will be trimmed to end with "and that's the way the cookie". Even if the entire word "crumbles" was there, it would still do the same. This is to avoid ending up with partial words.

## Installation

```elixir
def deps do
  [
    {:get_medium, "~> 0.1.0"}
  ]
end
```

## Using GetMedium
Using a URL created by RSS2JSON for your Medium blog, returns a list of your blog posts. Other services to get JSON for your Medium feed might work but the structure could be different and break the app.

Publications have a feed format of https://medium.brianemorycom/feed and personal feeds have a format of https://medium.com/feed/@thebrianemory. Using the URL and https://rss2json.com, you will get your feed in a JSON format.

Using RSS2JSON, you will get a URL for your API call. You will use that URL to fetch your feed in a JSON format. With RSS2JSON, you can use just your feed URL or you can register and use your API key to add more options like order by, order direction, and items count.

### RSS2JSON feed examples
Using an API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed&api_key=YOUR_API_KEY&count=3
No API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed

## Examples
```elixir
iex> use GetMedium
...> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY
...> GetMedium.Truncated.blog_posts_truncated(url, 304)
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
```
