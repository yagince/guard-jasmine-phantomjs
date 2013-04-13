require 'compiler/typescript'

module Guard
  class JasminePhantomjs
    module Runner
      class TypeScript
        def initialize(config)
          @config = config
        end

        def run(path)
          Compiler::TypeScript.new(path).compile
        end

        def run_all
          Dir.glob(file_pattern).each{|file| Compiler::TypeScript.new(file).compile }
        end

        private
        def file_pattern
          "#{@config.src_dir}/**/*.ts"
        end
      end
    end
  end
end
