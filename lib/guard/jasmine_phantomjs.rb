# -*- coding: utf-8 -*-
require 'yaml'
require "guard/jasmine_phantomjs/version"
require "guard/extention/hash"
require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class JasminePhantomjs < Guard
    require "guard/jasmine_phantomjs/runner/typescript"
    require "guard/jasmine_phantomjs/runner/jasmine"

    DEFAULT_OPTIONS = {
      compile: :typescript,
      config: 'config/jasmine_phantomjs.yml',
      any_return: false
    }

    def initialize(watchers = [], options = {})
      options = DEFAULT_OPTIONS.merge(options)
      super(watchers, check_compile_option(options))
      @config = YAML.load_file(options.config)
      @compile_runner = compile_runner(@config.merge(options))
      @jasmine_runner = Runner::Jasmine.new(@config)
    end

    # 起動時に実行される
    def start
      ::Guard::UI.info "Start jasmine-phantomjs."
      @compile_runner.run_all
    end

    # ファイル変更・追加・削除時に実行される
    def run_on_changes(paths)
      ::Guard::UI.info "Start compile #{paths}"
      compile_results = @compile_runner.run(paths)
      ::Guard::UI.info "Start compile finished."
      @jasmine_runner.run(paths) unless compile_error?(compile_results)
    end

    # Enter押下時に実行される
    def run_all
      ::Guard::UI.info "Start jasmine-phantomjs run_all ."
      compile_results = @compile_runner.run_all
      ::Guard::UI.info "scripts compile finished ."
      @jasmine_runner.run_all unless compile_error?(compile_results)
      ::Guard::UI.info "run_all finished ."
    end

    # Gets called when the Guard should reload itself.
    #
    # @raise [:task_has_failed] when run_on_change has failed
    #
    def reload
      ::Guard::UI.info "Start jasmine-phantomjs reload."
      start
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
    def compile_runner(config)
      # TODO: other compiler
      case config.compile
      when :typescript
        Runner::TypeScript.new(config)
      when :coffee
        Runner::TypeScript.new(config)
      else
        Runner::TypeScript.new(config)
      end
    end
    def compile_error?(results)
      results.map{|result| result.status}.include?(:error)      
    end
  end
end
