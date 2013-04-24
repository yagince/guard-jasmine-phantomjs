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
          ::Guard::UI.info "Start jasmine.(run_all)"
          notify([@spec_runner.run_all])
        end

        private
        def notify(results)
          results.compact.each{|result|
            ::Guard::UI.info "Jasmine execute result."
            type = failed_count(result) > 0 ? :failed : :success
            Notifier.notify result, {image: type}
            puts results[0] + "\n" if result
          }
          results
        end

        def failed_count(result)
          result.scan(/(\d+) failures/).map{|m| m.first.to_i }.inject(:+)
        end
      end
    end
  end
end
