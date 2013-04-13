module Compiler
  class Compiler
    def initialize(option={})
      @option = option
    end
    def compile(file_path)
      raise NotImplementedError, 'plese implement #compile'
    end
  end
end
