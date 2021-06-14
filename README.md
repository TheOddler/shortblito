# Feeld Interview Code Challenge

# Assignment

The challenge consists of creating a URL shortener.

Specifically, this is a web server that serves two routes:

    /shorten: Submit a url to shorten.
    /${url}: Follow a shortened url.

## Deviations from the assignment

Instead of having a `/shorten` route, you can simply `POST` to `/`.
This is so that "shorten" can still be used as one of the shortened keys.

# Solution

When visiting `/` you'll see a form where you can submit a url.
This will return a "short" for your url, which can then be used as `{host}/{short}`.

You can also shorten a url by posting to `/` and giving the url as body.
The body can contain an option `long=` prefix which allows for very easy use in the form.

## Details

Essentially the url shortener simply returns the database key, but this key is first shortened even more by making it base64 with a custom alphabet.
This shortened version of the key I call the "short".

When inserting the same url again, no new short is generated and the original short is returned.

## Thoughts

### Supporting named urls

With this I mean that instead of getting a random-looking short, you can actually choose the short to be anything you want.

This is currently not possible.
We could add support for this by for instance starting each non-named short with an `_` (`_` is 0 in the custom alphabet).
That way if a short starts with `_` we know it's an id and not a name.

To keep the link as short as possible, and the solution simpler, I decided not to do this.

Alternatively a different sub-domain with a different server could be used for named-urls.
For instance, the free version would only allow id's on domain `short.bli.to` where paid named-urls (for custom branding) would work under `p.bli.to`.

### Exposing database keys

The keys returned by the server are not random, they are the actual database keys.
This makes it easy to guess other urls, this also gives the user information about how many urls have been shortened already.

However, this also makes the server very efficient, as you can simply insert the new urls into the database without any extra work.
No need to check if the random key already exists, no inefficient index updates, and instant lookups.
Note that the serves does check if the long-url already exists to prevent duplicates, for more performance we could disable this if we don't care about duplicate urls in the database.

### Changing the base64 alphabet

Simply changing the alphabet and nothing else would break all previously made keys.
However, some solutions spring to mind:

* Prefixing new keys with a character not allowed in the old alphabet
  * This would be a nice solution if the old keys were already prefixed with `_` for instance, then it's easy to support different shortener versions as well as named shorts.
* A new sub-domain
* Actually saving the short to the database, and migrating the existing urls. This will however come at a performance cost.

# How to run

* Local dev server: run `./scripts/devel-shortblito-web-server.sh`
* Tests: `stack test`

# Thanks

Thanks to Syd for allowing me to use his web-server template: https://github.com/NorfairKing/template-web-server
