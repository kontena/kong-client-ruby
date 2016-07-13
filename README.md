# Kong Client for Ruby

[Kong](http://getkong.org) API client for Ruby

[![Build Status](https://travis-ci.org/kontena/kong-client-ruby.svg?branch=master)](https://travis-ci.org/kontena/kong-client-ruby)

## Installation
Add this line to your application's Gemfile:

    gem 'kong-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kong-client

## Usage

By default Kong client tries to connect `http://localhost:8001` or address provided by environment variable: `KONG_URI='http://your-kong-url:8001'`.

You can set it also in your code:
```ruby
require 'kong'
Kong::Client.api_url = 'http://your-kong-url:8001'
```

### Desing

Kong client follows a design of resoures as Plain Old Ruby objects(tm). For examples to create a new Consumer resource you can do it like this:

```ruby
consumer = Kong::Consumer.create({ username: 'testuser', custom_id: 'custom_id' })
```

OR

```ruby
consumer = Kong::Consumer.new({ username: 'testuser'})
consumer.custom_id = '12345'
consumer.save
```

To find existing consumer:

```ruby
consumer = Kong::Consumer.find_by_username('testuser')
consumer = Kong::Consumer.find_by_custom_id('custom_id')
```

### All Resources and Actions

#### Consumer

```ruby
Kong::Consumer.list(filters)
Kong::Consumer.all()
Kong::Consumer.find(id)
Kong::Consumer.find_by_*(value)
Kong::Consumer.create(attributes)

consumer = Kong::Consumer.new({ username: 'test-user' })
consumer.get # reloads resource
consumer.create
consumer.update
consumer.save # requests create_or_update action
consumer.delete

consumer.plugins
consumer.oauth_apps
consumer.key_auths
consumer.basic_auths
consumer.oauth2_tokens
```

#### API

```ruby
Kong::Api.list(filters)
Kong::Api.all()
Kong::Api.find(id)
Kong::Api.find_by_*(value)
Kong::Api.create(attributes)

api = Kong::Api.new({
  name: 'Mockbin',
  request_host: 'mockbin.com',
  request_path: '/someservice',
  strip_request_path: false,
  preserve_host: false,
  upstream_url: 'https://mockbin.com'
})
api.get # reloads resource
api.create
api.update
api.save # requests create_or_update action
api.delete

api.plugins
```

#### Plugin

```ruby
Kong::Plugin.list(filters)
Kong::Plugin.all()
Kong::Plugin.find(id)
Kong::Plugin.find_by_*(value)
Kong::Plugin.create(attributes)

plugin = Kong::Plugin.new({
  api_id: '5fd1z584-1adb-40a5-c042-63b19db49x21',
  consumer_id: 'a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4',
  name: 'rate-limiting',
  config: {
    minute: 20,
    hour: 500
  }  
})

plugin.get # reloads resource
plugin.create
plugin.update
plugin.save # requests create_or_update action
plugin.delete
```

#### OAuthApp

```ruby
Kong::OAuthApp.list(filters)
Kong::OAuthApp.all()
Kong::OAuthApp.find(consumer_id)
Kong::OAuthApp.find_by_*(value)
Kong::OAuthApp.create(attributes)

app = Kong::OAuthApp.new({  
  consumer_id: 'a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4',  
  redirect_uri: 'http://some-domain/endpoint/'
})

app.create
app.get # reloads resource
app.update
app.save # requests create_or_update action
app.delete
```

#### KeyAuth

```ruby
Kong::KeyAuth.create(attributes)

auth = Kong::KeyAuth.new({  
  consumer_id: 'a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4',    
})

auth.create
auth.get # reloads resource
auth.update
auth.save # requests create_or_update action
auth.delete
```

#### BasicAuth

```ruby
Kong::KeyAuth.create(attributes)

auth = Kong::BasicAuth.new({  
  consumer_id: 'a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4',
  username: 'user123',
  password: 'secret'
})

auth.create
auth.get # reloads resource
auth.update
auth.save # requests create_or_update action
auth.delete
```

#### OAuth2Token

```ruby
token = Kong::OAuth2Token.find_by_access_token('SOME-TOKEN')

token = Kong::OAuth2Token.new({  
  credential_id: 'KONG-APPLICATION-ID',
  token_type: 'bearer',
  access_token: 'SOME-TOKEN',
  refresh_token: 'SOME-TOKEN',
  expires_in: 3600
})

token.create
token.update
token.save # requests create_or_update action
token.delete
```

## Contributing

1. Fork it ( https://github.com/kontena/kong-client-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
