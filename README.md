# Anymock

Simple mock server.
Print request params to response and STDOUT.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'anymock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anymock

## Options

```
-d [DIR] specify document root (default: './public')
-h [HOST] speify host name (default: 'localhost')
-p [PORT] specify port number (default: '8080')
-m puts response to STDOUT
```

## Example

    $ anyock -d ./files -h localhost -p 8100 -m

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nysalor/anymock.
