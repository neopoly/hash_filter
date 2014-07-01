# HashFilter

[![Build Status](http://img.shields.io/travis/neopoly/hash_filter.svg?branch=master)](https://travis-ci.org/neopoly/hash_filter) [![Gem Version](http://img.shields.io/gem/v/hash_filter.svg)](https://rubygems.org/gems/hash_filter) [![Code Climate](http://img.shields.io/codeclimate/github/neopoly/hash_filter.svg)](https://codeclimate.com/github/neopoly/hash_filter) [![Inline docs](http://inch-ci.org/github/neopoly/hash_filter.svg?branch=master)](http://inch-ci.org/github/neopoly/hash_filter)

A simple hash filter.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_filter

## Usage

```ruby

  remove_images = HashFilter.new do
    delete /\.jpg$/
    delete /\.png$/
    delete /\.gif$/
  end

  rename_html = HashFilter.new do
    rename /(.*?)\.htm$/, '\1.html'
  end

  filter = HashFilter.new do
    inject remove_images
    inject rename_html
  end

  hash = {
    "image.jpg" => "/path/to/image.jpg",
    "image.png" => "/path/to/image.png",
    "page.htm"  => "/path/to/page.html"
  }

  p filter.apply hash
  # {
  #   "page.html" => "/path/to/page.html"
  # }

```

## Contributing

1. Fork it ( https://github.com/neopoly/hash_filter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Releasing

1. Edit version.rb
2. Add changes to CHANGELOG.md
3. `rake release`
