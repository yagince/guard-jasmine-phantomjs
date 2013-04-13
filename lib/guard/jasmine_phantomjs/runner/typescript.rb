require 'compiler/typescript'

module Guard
  class JasminePhantomjs
    module Runner
      class TypeScript
        def initialize(config)
          @config = config
          @compiler = Compiler::TypeScript.new(config)
        end

        def run(file_path)
          @compiler.compile(file_path)
        end

        def run_all
          Dir.glob(file_pattern).each{|file| @compiler.compile(file) }
        end

        private
        def file_pattern
          "#{@config.src_dir}/**/*.ts"
        end
      end
    end
  end
end
