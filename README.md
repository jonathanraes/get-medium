# GetMedium

GetMedium is an Elixir package to solve the problem of Medium's API not having a way to get your blog posts. Medium's API currently only allows posting to your blog which is a problem for those of us who want to display all or part of our recent posts on our personal site.

GetMedium returns a truncated version of your Medium blog posts. It requires your Medium RSS URL (see below for details), and the number of characters to truncate at. The default value is set to 304 (305 characters when zero indexed). This will truncate your content at 305 characters, then trim that down passed the last space " ".

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
Using a URL created by RSS2JSON for your Medium blog, it returns a list of your truncated blog posts (default is set to return 305 characters). Other services to get JSON for your Medium feed might work but the structure could be different and may break the app.

Publications have a feed format of https://medium.brianemorycom/feed and personal feeds have a format of https://medium.com/feed/@thebrianemory. Using the URL and https://rss2json.com, you will get a URL for an API call to return you feed in a JSON format. With RSS2JSON, you can use just your feed URL or you can register and use your API key to add more options like order by, order direction and items count.

### RSS2JSON feed examples
Using an API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed&api_key=YOUR_API_KEY&count=3
No API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed

## How it works
Calling `GetMedium.Truncated.blog_posts(url)`, where `url` is the URL to the API call you got from RSS2JSON, `HTTPoison` and `Poison` are used to fetch and parse the JSON. This returns a list of your posts.

## Examples
A simple example of how it works. I am using my publications's RSS feed, I have registered with RSS2Json so I can use my API key to return only the last three of my blog posts.
```elixir
iex> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
...> GetMedium.Truncated.blog_posts(url)
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

You can also use pattern matching to easily access each post separately.
```elixir
iex> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
...> [first, second, third] = GetMedium.Truncated.blog_posts(url)
...> first.title
"A Newsletter Sending System Code Challenge"
```
## Potential issues
Currently, it should be able to handle different varieties of Medium blog posts. For example, my blog posts always start with an image, followed by a subheading, then the main content. It should also be able to handle posts that do not start with an image and/or subheading. Please open up an issue if this is not behaving as intended.

If you have a URL in your post, you may get weird results. This is something I will be looking into.

## Roadmap
- Returning the raw HTML for the content
- Handling URLs in a non-destructive manner
- Module to return posts without them being truncated
- Improve testing to use mocks and ensure each part of the data is returned

## License
Copyright (c) 2017 Brian Emory

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
