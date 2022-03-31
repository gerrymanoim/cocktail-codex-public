# Cocktail Codex

*Status: Feature complete, never to be public.*

This serves as a guide of what I did and how it works. I realized that I'm not going to clean this up to make it production worthy, but I wanted to write up what I did and how it works for my future self (and anyone else who may find this helpful).

**Problem**: I have a few different sites and newsletters that I go to for cocktail recipes. "Browsing" and "Searching" them together as one collection was painful. There are various recipe apps and blogging software that would let me put all this information in one place, but copy/pasting it manually seemed tedious and keeping it up to date was going to be challenging.

**Solution**: Self hosted static search engine. I previously read about/[played with](https://github.com/gerrymanoim/static-searcher) static search engines and figured this would actually be a good fit here. So the plan:

1. Scrape all relevant pages.
2. Index all those pages.
3. Run a static search engine on top of the index
4. Self host

## Scraping

Scraping for this project was not complicated. I built a small `ingest` cli entry point that took a list of site and built small list of parsers per domain. Parsers were either done using [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) or direct APIs (such as [PRAW](https://praw.readthedocs.io/en/stable/)) where possible.

Importantly, because I originally thought this was going to be a [datasette](https://datasette.io/) backed project, I saved the text and raw html into a sqlite table.

```sql
CREATE TABLE posts (
    url TEXT NOT NULL,
    site_name TEXT NOT NULL,
    title TEXT,
    content_html TEXT,
    content_text TEXT
)
;
```

This was mostly a happy accident, but made future iteration on the parsed content way way easier (especially around playing around with templates). I could have also saved down each page itself, but it was easier to keep the raw data + metadata about that data in a table than on the filesystem.

### Static Page Generation

Now that content is in the database, we have a small script that:

1. Extracts the content and puts it inside a jinja template. This jinja template serves to apply consistent styling to the content and make sure everything looks good on mobile (via Bootstrap). See the tempaltes directory for detail. Some of the html is also modified (for example, adding `class="img-fluid` to all images so they'd work on mobile).
2. Puts a list of all the pages into an `all.html` file.
3. Builds the configuration for the static indexer.

This takes under a second end to end for the ~200 posts I have saved.

## Indexing

We use the fantastic [Stork](https://stork-search.net/) to create a static search engine. It comes in two parts:

1. A CLI that generates the index file
2. A bit of JS that loads the index file.

See their docs for more, but it works perfectly for this usecase.

## Self hosting

Since everything is static, everything gets copied over to a RaspberryPi which is running nginx. This can be accessed on the LAN or externally with Tailscale, etc.

## Result

## TODO

- Add recent to the index page
- fix fts tables?
- caching of stork?
