# Librarix

Manage all your collections in your browser and automatically fetch infos from TheMovieDB

## Installation

Librarix is a simple Sinatra app that can be used as a standalone app or mounted in another app.

### Standalone

Create a Gemfile and add this line:

```ruby
gem 'librarix'
```

And then execute:

```sh
$ bundle
```

Finally, you need a `config.ru` file to launch the Rack application:
```ruby
require 'librarix'

Tmdb::Api.key('THE_MOVIE_DB_API_KEY')
Librarix.redis = Redis.new # use the correct host, port and db number for your redis database

run Librarix::Application
```
