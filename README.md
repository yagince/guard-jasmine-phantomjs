# Guard::JasminePhantomjs

For the project to develop a javascript library with TDD(Jasmine)

## Requires

- TypeScript (requires tsc command)
`npm install typescript`
- PhantomJs
`brew install phantomjs`

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

`config/jasmine_phantomjs.yml` ***# deprecated***

    :jasmine_version: '1.3.1'
    :src_dir: 'src'
    :spec_dir: 'spec'
    :phantomjs: :gem 
    :out: 'src/all.js'
    :root_script: 'src/all.ts'

`Guardfile` sample

    guard :jasmine_phantomjs, {
      config: 'path/to/config-file',
      compile: :typescript
      src_dir: 'src',
      spec_dir: 'spec',
      jasmine_version: '1.3.1',
      phantomjs: :gem
      # , out: 'src/all.js'
      # , root_script: 'src/root.ts'
      # , reporter: :html
      # , lib: 'lib'
    } do
      watch(%r{src/(.+?)\.ts$})
      watch(%r{spec/(.+?)\Spec.js$}){|m| "src/#{m[1]}.ts" }
    end

`guard` options

- config:
  - config-file's path. `config/jasmine_phantomjs.yml` is default.
- compile:
  - source file type
  - `:typescript`
  - `:coffee` **# TODO**
- jasmine_version: 
  - your jasmine's `version`.
- src_dir: 
  - main source directory path 
- spec_dir: 
  - jasmine's spec directory path
- phantomjs: 
  - how to run phantomjs. `:gem` or `:native`
- out: 
  - add `--out` option when compile typescript
- root_script: 
  - if you define this option, compile this file which files are changed.
- reporter:
  - `:html` (default)
    - generate SpecRunner.html for `HtmlReporter` of jasmine
  - `:phantomjs`
    - generate SpecRunner.html for `PhantomJsReporter` of jasmine
- lib:
  - if you define this option, write `<script src="../xx/xx.js"></script>` all the js files in that directory.

### Run

in your `terminal`

    $ bundle exec guard
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
