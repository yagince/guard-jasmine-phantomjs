require 'yaml'
require "guard/jasmine_phantomjs/version"
require "guard/extention/hash"

require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class JasminePhantomjs < Guard
    DEFAULT_OPTIONS = {
      compile: :typescript,
      config: 'config/jasmine.yml',
      any_return: false
    }
    def initialize(watchers = [], options = {})
      options = DEFAULT_OPTIONS.merge(options)
      super(watchers, check_compile_option(options))
      @config = YAML.load_file(options.config)
    end

    def start
      Dir.glob(file_pattern).map{|file| compiler(file).compile }
    end

    private
    def check_compile_option(options)
      tmp = options.dup
      if options[:compile] and ![:coffee, :typescript].include?(options[:compile])
        tmp[:compile] = :typescript
      end
      tmp
    end
    def compiler(file)
      case options.compile
      when :typescript
        Compiler::TypeScript.new file
      else
        Compiler::TypeScript.new file
      end
    end
    def file_pattern
      case options.compile
      when :typescript
        "#{@config.src_dir}/**/*.ts"
      else
        "#{@config.src_dir}/**/*.ts"
      end
    end
  end
end
