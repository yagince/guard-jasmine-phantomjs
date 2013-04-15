require 'compiler/typescript'
require 'jasmine/spec_runner'

module Guard
  class JasminePhantomjs
    module Runner
      class Jasmine
        def initialize(config)
          @config = config
          @spec_runner = ::Jasmine::SpecRunner.new(config)
        end

        def run(file_paths)
          ::Guard::UI.info "Start jasmine."
          notify([@spec_runner.run(file_paths)])
        end

        def run_all
          ::Guard::UI.info "Start jasmine."
          notify([@spec_runner.run_all])
        end

        private
        def notify(results)
          ::Guard::UI.info "Jasmine result."
          Notifier.notify results[0] 
          puts results[0] + "\n" if results[0]
          results
        end
      end
    end
  end
end
