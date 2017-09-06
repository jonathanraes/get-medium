# GetMedium

GetMedium is an Elixir package to solve the problem of Medium's API not having a way to get your blog posts. Medium's API currently only allows posting to your blog which is a problem for those of us who want to display all or part of our recent posts on our personal site.

GetMedium returns your Medium blog posts or a truncated version of your blog post's content. Using `GetMedium.Full.blog_posts` and `GetMedium.Truncated.blog_posts` only requires your Medium RSS URL (see below for details). By default, both will return the content with the HTML tags removed. If you would like the raw HTML, you can pass `raw: true` as an argument.

By default, `GetMedium.Truncated.blog_posts` will truncate your blog posts content to 305 characters, then trim that down passed the last space " ". For example, if your post ends with "and that's the way the cookie crum", your content will be trimmed to end with "and that's the way the cookie". Even if the entire word "crumbles" was there, it would still do the same. This is to avoid ending up with partial words.

## Installation

```elixir
def deps do
  [
    {:get_medium, "~> 0.3.0"}
  ]
end
```

## Using GetMedium
Using a URL created by RSS2JSON for your Medium blog, it returns a list of your blog posts or truncated blog posts (default is set to return 305 characters). Other services to get JSON for your Medium feed might work but the structure could be different and may break the app. This will evnetually be a non-issue when GetMedium is update to not rely on RSS2JSON.

Publications have a feed format of https://medium.brianemorycom/feed and personal feeds have a format of https://medium.com/feed/@thebrianemory. Using the URL and https://rss2json.com, you will get a URL for an API call to return your feed in a JSON format. With RSS2JSON, you can use just your feed URL or you can register and use your API key to add more options like order by, order direction, and items count.

### RSS2JSON feed examples
Using an API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed&api_key=YOUR_API_KEY&count=3
No API key: https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Ffeed

## How it works
When calling `GetMedium.Truncated.blog_posts(url)`, where `url` is the URL to the API call you get from RSS2JSON, `HTTPoison` and `Poison` are used to fetch and parse the JSON. This returns a list of your posts. Calling `GetMedium.Full.blog_posts(url)` works the same way while returning the full content of your blog posts. By default, `GetMedium.Truncated.blog_posts` truncates the content at 305 characters. You can change the number of characters by passing `characters: 500` (where 500 is the value you want to truncate at). Both `GetMedium.Truncated.blog_posts` and `GetMedium.Full.blog_posts` return the content with the HTML tags removed. If you would like the raw HTML content, you can pass in `raw: true` as an argument.

## Examples using default characters and returning content with HTML tags removed
An example of how it works. I am using my publications's RSS feed, I have registered with RSS2Json so I can use my API key to return only the last three of my blog posts.
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

## Example for returning the raw HTML and an example for returning a content with a higher character count
Here is an example of passing `raw: true` to get the raw HTML for your content.
```elixir
iex> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
...> GetMedium.Truncated.blog_posts(url, raw: true)
[%{categories: ["bootstrap", "programming", "web-development", "elixir",
    "phoenix"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1024/1*G7GdGzUPNKH3RS9owmt5SQ.png\"></figure><h4>Time to try it out</h4>\n<p><a href=\"https://getbootstrap.com/\">Bootstrap 4</a> is finally out of alpha and into beta. I have stayed away from Bootstrap 4 while it was in alpha. Now that it is in...",
   date: "Aug 30, 2017",
   link: ["https://medium.brianemory.com/elixir-phoenix-installing-bootstrap-4-beta-9e2f2d73bd83"],
   subheading: "Time to try it out",
   title: "Elixir Phoenix: Installing Bootstrap 4 Beta"},
 %{categories: ["web-development", "education", "elixir", "phoenix",
    "programming"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1000/1*TOaNlUZK4ZoFAH9pJhbsmA.png\"></figure><h4>Teaching while learning</h4>\n<p>Back in April, I started learning Elixir and Phoenix. It was the second programming language I learned and my first functional programming language. It was quite...",
   date: "Aug 28, 2017",
   link: ["https://medium.brianemory.com/elixir-phoenix-creating-an-app-with-tests-updated-for-phoenix-1-3-3cc8b5cf3601"],
   subheading: "Teaching while learning",
   title: "Elixir Phoenix: Creating An App With Tests (Updated for Phoenix 1.3)"},
 %{categories: ["elixir", "medium", "web-development", "programming", "blog"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1024/1*hQ1TWXgP_kCM_skYwjzkYA.png\"><figcaption>GetMedium in action on <a href=\"https://www.brianemory.com/\">https://www.brianemory.com</a></figcaption></figure><h4>By Using GetMedium</h4>\n<p>You know what isn’t easy to do? Display your Medium...",
   date: "Aug 15, 2017",
   link: ["https://medium.brianemory.com/elixir-display-your-medium-posts-on-your-website-39c1b6082deb"],
   subheading: "By Using GetMedium",
   title: "Elixir: Display Your Medium Posts on Your Website"}]
```

Here is an example of passing `raw: true` to get the raw HTML for your content and also passing `characters: 500` to increase the number of characters in the blog post's content.
```elixir
iex> url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fmedium.brianemory.com%2Frss&api_key=YOUR_API_KEY&count=3"
...> GetMedium.Truncated.blog_posts(url, raw: true, characters: 500)
[%{categories: ["bootstrap", "programming", "web-development", "elixir",
    "phoenix"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1024/1*G7GdGzUPNKH3RS9owmt5SQ.png\"></figure><h4>Time to try it out</h4>\n<p><a href=\"https://getbootstrap.com/\">Bootstrap 4</a> is finally out of alpha and into beta. I have stayed away from Bootstrap 4 while it was in alpha. Now that it is in beta and I am updating one of my projects to Phoenix 1.3, it is a good time to try it out.</p>\n<p>This will involve removing Bootstrap 3 from the phoenix.css, installing Bootstrap and jQuery...",
   date: "Aug 30, 2017",
   link: ["https://medium.brianemory.com/elixir-phoenix-installing-bootstrap-4-beta-9e2f2d73bd83"],
   subheading: "Time to try it out",
   title: "Elixir Phoenix: Installing Bootstrap 4 Beta"},
 %{categories: ["web-development", "education", "elixir", "phoenix",
    "programming"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1000/1*TOaNlUZK4ZoFAH9pJhbsmA.png\"></figure><h4>Teaching while learning</h4>\n<p>Back in April, I started learning Elixir and Phoenix. It was the second programming language I learned and my first functional programming language. It was quite a shift in thinking coming from Ruby on Rails. Since Elixir and Phoenix were written by people with a Rails background, you will find some similarities. Even though they are vastly different, I...",
   date: "Aug 28, 2017",
   link: ["https://medium.brianemory.com/elixir-phoenix-creating-an-app-with-tests-updated-for-phoenix-1-3-3cc8b5cf3601"],
   subheading: "Teaching while learning",
   title: "Elixir Phoenix: Creating An App With Tests (Updated for Phoenix 1.3)"},
 %{categories: ["elixir", "medium", "web-development", "programming", "blog"],
   content: "\n<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/1024/1*hQ1TWXgP_kCM_skYwjzkYA.png\"><figcaption>GetMedium in action on <a href=\"https://www.brianemory.com/\">https://www.brianemory.com</a></figcaption></figure><h4>By Using GetMedium</h4>\n<p>You know what isn’t easy to do? Display your Medium blog posts on your website. You know what can be easy to do? Display your Medium blog posts on your website.</p>\n<p>I first bumped up into this problem when I made my personal site using Rails....",
   date: "Aug 15, 2017",
   link: ["https://medium.brianemory.com/elixir-display-your-medium-posts-on-your-website-39c1b6082deb"],
   subheading: "By Using GetMedium",
   title: "Elixir: Display Your Medium Posts on Your Website"}]
```

## Potential issues
Currently, it should be able to handle different varieties of Medium blog posts. For example, my blog posts always start with an image, followed by a subheading, then the main content. It should also be able to handle posts that do not start with an image and/or subheading. Please open up an issue if this is not behaving as intended.

GetMedium relies on https://rss2json.com to turn your RSS feed into JSON. The
service could go down or cease to exist which means your posts will not be able
to be retrieved until it comes back online. A top priority will be to not rely
on RSS2JSON to avoid that ever being an issue.

If you have a URL in your post, you may get weird results. This is something I will be looking into.

## Roadmap
- [ ] Remove reliance on RSS2JSON
- [x] Returning the raw HTML for the content
- [ ] Handling URLs in a non-destructive manner
- [x] Module to return posts without them being truncated
- [ ] Improve testing to use mocks and ensure each part of the data is returned
- [ ] Add image URL if the post has an image

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