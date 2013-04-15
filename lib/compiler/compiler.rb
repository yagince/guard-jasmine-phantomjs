module Compiler
  class Compiler
    def initialize(options={})
      @options = options
    end
    def compile(file_path)
      raise NotImplementedError, 'plese implement #compile'
    end
  end
end
