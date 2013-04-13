require 'tempfile'
require 'compiler/compiler'
require 'childprocess'
require 'typescript'

module Compiler
  class TypeScript < Compiler
    BASE_DIR = File.expand_path(File.dirname(__FILE__))

    def compile
      compile_with_child_process # TODO: switch
    end

    private
    def compile_with_child_process
      io_in, io_out = IO.pipe
      Process.waitpid(spawn("tsc #{@file}", [:out, :err] => io_out))
      io_out.close
      {message: io_in.read, status: $?.exitstatus.zero? ? :success : :error}
    end

    def compile_with_gem
      ENV['TYPESCRIPT_LIB_PATH'] = "#{BASE_DIR}/typescript/lib.d.ts"
      ENV['TYPESCRIPT_COMPILER_PATH'] = "#{BASE_DIR}/typescript/tsc.js"
      ENV['TYPESCRIPT_SOURCE_PATH'] = "#{BASE_DIR}/typescript/typescript.js"
      result = nil
      begin
        # ::TypeScript::Source.path=ENV['TYPESCRIPT_SOURCE_PATH']
        compiled_source = ::TypeScript.compile(File.read(@file))
        open(@file.sub(".ts",".js"), 'w') {|file| file.write(compiled_source)}
      rescue => e
        # puts e
        # puts e.backtrace
        result = {message: e.message, status: :error}
      end
      result || {message: "", status: :success}
    end
  end
end
