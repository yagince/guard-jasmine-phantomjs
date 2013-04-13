module Compiler
  class Compiler
    def initialize(file, option={})
      @file = file
      @option = option
    end
    def compile
      raise NotImplementedError, 'plese implement #compile'
    end
  end
  class StdOutBuffer
    def initialize
      @buf = []
    end
    def write(data)
      buf << data
    end
    def message
      @buf.dup
    end
  end
end
