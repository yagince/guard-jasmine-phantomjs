# Guard::JasminePhantomjs

For the project to develop a javascript library with TDD(Jasmine)

## Installation

Add this line to your application's Gemfile:

    gem 'guard'
    gem 'guard-jasmine-phantomjs'

And then init:

    $ bundle exec guard init jasmine_phantomjs

And then execute:

    $ bundle exec guard

Or install it yourself as:

    $ gem install guard guard-jasmine-phantomjs

## Usage

### Configuration

config/jasmine-phantomjs.yml

    src_dir: 'src' # main source directory path
    spec_dir: 'spec' # jasmine's spec directory path

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
