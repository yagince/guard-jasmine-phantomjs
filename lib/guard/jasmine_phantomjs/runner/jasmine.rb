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
          [@spec_runner.run(file_paths)]
        end

        def run_all
          [@spec_runner.run_all]
        end
      end
    end
  end
end
