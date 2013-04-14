# Guard::JasminePhantomjs

For the project to develop a javascript library with TDD(Jasmine)

## Installation

Add this line to your application's Gemfile:

    gem 'guard'
    gem 'guard-jasmine-phantomjs', :git => 'git://github.com/yagince/guard-jasmine-phantomjs.git'

And then init:

    $ bundle exec guard init jasmine_phantomjs

And then execute:

    $ bundle exec guard

## Usage

### Configuration

`config/jasmine-phantomjs.yml`

    jasmine_version: '1.3.1' # your jasmine version
    src_dir: 'src' # main source directory path
    spec_dir: 'spec' # jasmine's spec directory path

`Guardfile`'s sample

    guard :jasmine_phantomjs, compile: :typescript do
      watch(%r{^src\/(.+?)\.ts$})
      watch(%r{^spec/(.+?)\Spec.js$}){|m| "src/#{m[1]}.ts" }
    end

`guard` options

- compile
    - :typescript
    - :coffee # TODO

### Run

in your `terminal`

    $ bundle exec guard
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
