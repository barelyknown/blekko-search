# Blekko

Search the Internet (or parts of the Internet!) with ease. This gem is powered by [blekko.com](http://www.blekko.com).

This gem is based on work done on [earmarkd.com](http://www.earmarkd.com) during [RailsRumble 2012](http://railsrumble.com).

## Installation

Add this line to your application's ``Gemfile``:

    gem 'blekko-search'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install blekko-search

## Usage

Use this gem for quick searches or to manage groups of slashtags and more complicated search goals.

### Searching

While blekko asks that you [request an API key](http://help.blekko.com/index.php/does-blekko-have-an-api/), you don't need one to start.

    blekko = Blekko.new

While blekko is known for their slashtag based searching, you can search without one:

    results = blekko.search("chicago")

The search method returns an array of ``SearchResult`` instances that expose all blekko attributes (and a few more).

If you want to search using [blekko slashtags](http://blekko.com/tag/show), include a ``:slashtags`` argument in your search.

    results = blekko.search("chicago", slashtags: "/sports")

Blekko allows for a maximum of 100 results per search, but if you'd like more, you can set the ``:total_size`` argument. 

    results = blekko.search("something funny", total_size: 1000)

By default, the searches will be made 100 results at a time, but you can reduce the page size using the ``:page_size`` argument too.

Blekko asks that users of its API limit searches to one per second. This gem doesn't include that, but you may want to implement that feature (or send a pull request) especially if you are multithreading the search.

#### Results
Each result includes the attributes that blekko provides, plus a couple more:

- ``n_group`` (alias: ``sequence``) = The number of the search result in the overall results from blekko.
- ``url`` = The url of the result.
- ``display_url`` = A url formatted for display.
- ``rss`` = The rss of the result, if available.
- ``rss_title`` = The title of the rss of the result, if available.
- ``short_host_url`` = The url of the host of the result.
- ``short_host`` = The url of the host formatted for display.
- ``snippet`` (alias: ``abstract``) = A description of the result formatted for display including html
- ``toplevel`` = Is the result a top level domain?
- ``url_title`` = The title of the url formatted for display including html
- ``date`` = The date of the the result's document, if available. Parsed from ``doc_date_iso``.
- ``address`` = The address of the result, if available (not too often).
- ``geocluster`` = The geocluster of the result, if avaiable.
- ``lat`` = The lat of the result, if available.
- ``lon`` = The lon of the result, if available.
- ``phone`` = The phone number of the result, if available.
- ``zip`` = The zip of the result, if available.
- ``is_robots_banned`` = Does this result ban robots? Almost never available.

### Slashtags
From ["What is a slashtag?" on blekko.com](http://help.blekko.com/index.php/what-is-a-slashtag/):
>A slashtag is an easy-to-create custom search engine. It is a tool used to filter search results and helps you to search only high quality sites, without spam or content farms. Slashtags contain a list of websites and when you search with a slashtag, you only search those sites. Some slashtags perform functions such as ordering the results by date.

#### View
You can view the urls for any slashtag that is public, or for any private slashtag that you have access to if you are logged in.

    slashtag = blekko.slashtag("/sports")

By default, the slashtag will load the urls from blekko if the slashtag exists.

    urls = blekko.slashtag("/sports").urls
    
Prevent the slashtag from loading its ``urls`` automatically by setting the ``:eager_load`` argument to ``false``.

    slashtag = blekko.slashtag("/sports", eager_load: false)
    
Access the urls currently saved on blekko.com at any point:

    slashtag.saved_urls

#### Create & Edit
To create or edit a slashtag you'll need to use a blekko instance that has logged in using it's username and password.

    blekko = Blekko.new(username: "derekrose", password: "comeback", api_key: "1")

You will be logged in automatically if you provide all three credentials when you create the Blekko instance. Otherwise, you can call the ``login`` method to authenticate.

    blekko = Blekko.new
    blekko.username = "derekrose"
    blekko.password = "comeback"
    blekko.api_key = "1"
    blekko.login

Create a slashtag using the same syntax as used for the view method. You can pass in the ``urls`` when you initialize a new instance.

    slashtag = blekko.slashtag("/my/sports", urls: ["http://www.espn.com", "http://http://sportsillustrated.cnn.com"])

You can add urls to an existing slashtag object.

    slashtag = blekko.slashtag("/my/sports")
    slashtag.urls << "http://www.espn.com"

To save the slashtags to blekko call ``save!``. This will either create a new slashtag or update the existing slashtag.

    slashtag.save!

#### Remove URLS

You can also remove URLs from a slashtag.

    slashtag = blekko.slashtag("/my/sports")
    slashtag.remove_urls!("http://www.espn.com")

#### Delete

The API does not currently support deleting slashtags. You'll need to login to [blekko.com](http://www.blekko.com) to delete a slashtag from your account.

## Acknowlegements
Thanks to [blekko.com](http://www.blekko.com) for providing API access to their search engine.

<3 [@barelyknown](http://www.twitter.com/barelyknown)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. Thank you :)