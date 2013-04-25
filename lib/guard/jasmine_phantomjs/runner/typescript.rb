require 'compiler/typescript'

module Guard
  class JasminePhantomjs
    module Runner
      class TypeScript
        def initialize(config)
          @config = config
          @compiler = Compiler::TypeScript.new(config)
        end

        def run(file_paths)
          notify(file_paths.map{|path| @compiler.compile(path) })
        end

        def run_all
          case @config[:root_script]
          when String
            notify([@compiler.compile(@config.root_script)])
          else
            notify(Dir.glob(file_pattern).map{|file| @compiler.compile(file) })
          end
        end

        private
        def file_pattern
          "#{@config.src_dir}/**/*.ts"
        end
        def notify(results)
          results.each{|result|
            unless result.message.empty?
              ::Guard::UI.error "Compile Error!"
              Notifier.notify result.message, {image: :failed }
              puts "\x1b[31m#{result.message}\x1b[39m"
            end
          }
          results
        end
      end
    end
  end
end
