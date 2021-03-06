[![Build Status](https://travis-ci.org/llopez/rasck.svg?branch=master)](https://travis-ci.org/llopez/rasck)

# Rasck

Rails Service Checker is a Ruby library. 
It could be used as a simple library or you can make use of it through his built-in middleware.

* It provides a /rasck/status endpoint
* It provides some built_in checks like `redis` and `s3`
* It provides a way to add your custom checks

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rasck', github: 'llopez/rasck'
```

And then execute:

    $ bundle

## Setup

Add this line to your `config/application.rb`, this will insert the middleware

```ruby
config.middleware.insert_before Rails::Rack::Logger, Rasck::Middleware
```

Copy the below template to `config/initializers/rasck.rb`

```ruby
Rasck.configure do |config|
  # add security
  # uncomment next line to enable token authentication
  # config.auth_token = 'TOKEN'

  # change the status endpoint
  config.endpoint = '/status'

  config.add_custom_check 'service-1' do
    # custom check code goes here...
    # the code here should return a boolean value
  end

  config.add_custom_check 'service-2' do
    # custom check code goes here...
    # the code here should return a boolean value
  end
end
```

## Usage

Just GET /rasck/status endpoint to get a json object containing the status of your services

```json
{
  "redis": true,
  "s3": true,
  "service-1": true,
  "service-2": false
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/llopez/rasck.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
