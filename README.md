# Plesk for Ruby

A library to help with accessing the Plesk API.

## Installation

Add the gem to your `Gemfile`.

```ruby
gem 'plesk-ruby', '~> 1.0', :require => 'plesk'
```

## Usage

```ruby
require 'plesk'

client = Plesk::Client.new('mypleskhost.atech.io', 'admin', 'password')

# If you're not running port 8443
client.options[:port] = 8123

# If you don't want to verify the SSL certificate
client.options[:verify_ssl] = false

# Make a request
xml = client.request('customer', 'get') do
  filter do
    id 1
  end

  dataset do
    gen_info
    stat
  end
end

# Do something with the result
puts xml.xpath('//result/data/gen_info/pname').first&.content

# Catch errrors by rescuing the following exceptions
Plesk::Client::Error              #=> All errors
Plesk::Client::RequestError       #=> Request errors (parser errors etc...)
Plesk::Client::ActionError        #=> Action errors (resource not found etc...)
```
