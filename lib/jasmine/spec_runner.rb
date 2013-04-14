require 'erb'
require 'fileutils'
require 'guard/extention/hash'
require 'phantomjs'

module Jasmine
  class SpecRunner
    SPEC_RUNNER_HTML_NAME = "SpecRunner.html"
    SPEC_RUNNER_TEMPLATE = File.read("#{File.expand_path(File.dirname(__FILE__))}/#{SPEC_RUNNER_HTML_NAME}.erb")
    RUN_JASMINE_SCRIPT = "run-jasmine-incomplete.coffee"

    def initialize(config)
      @config = config
      @template = ERB.new(SPEC_RUNNER_TEMPLATE)
    end

    def run(paths)
      generate_spec_runner_html(paths)
      run_phantomjs
    end

    def run_all
      generate_spec_runner_html(Dir.glob("#{@config.spec_dir}/**/*.js"))
      run_phantomjs
    end

    def generate_spec_runner_html(paths)
      copy_libs(@config.spec_dir, @config.jasmine_version)
      copy_css(@config.spec_dir, @config.jasmine_version)

      source_paths = Dir.glob("#{@config.src_dir}/**/*.js")
      spec_paths = paths.map{|path| to_spec(path) }
      open("#{@config.spec_dir}/#{SPEC_RUNNER_HTML_NAME}", "w"){|file| file.write(@template.result(binding)) }
    end

    private
    JS_EXTENTION = ".js"
    SPEC = "Spec.js"
    EXTENTION_REGEX = /.+(\..+$)/
    JASMINE_LIBS = ['jasmine.js', 'jasmine-html.js']
    JASMINE_CSS = 'jasmine.css'

    def to_js(path)
      path.end_with?(JS_EXTENTION) ? path : path.sub(path.match(EXTENTION_REGEX){|m| m[1]}, JS_EXTENTION)
    end
    def to_spec(path)
      path.end_with?(SPEC) ? path : path.sub(path.match(EXTENTION_REGEX){|m| m[1]}, SPEC)
    end

    def copy_libs(spec_dir, version)
      if exist_libs(spec_dir).empty?
        lib_dir = FileUtils.mkdir_p("#{spec_dir}/lib/jasmine-#{version}")[0]
        FileUtils.copy(JASMINE_LIBS.map{|lib| "#{current_dir}/jasmine-#{version}/#{lib}"}, lib_dir)
        JASMINE_LIBS.map{|lib| "#{lib_dir}/#{lib}"}
      end
    end

    def copy_css(spec_dir, version)
      lib_dir = "#{spec_dir}/lib/jasmine-#{version}"
      dest_css = "#{lib_dir}/#{JASMINE_CSS}"
      unless File.exist?(dest_css)
        FileUtils.mkdir_p(lib_dir) unless Dir.exist?(lib_dir)
        FileUtils.copy("#{current_dir}/jasmine-#{version}/#{JASMINE_CSS}", dest_css)
      end
    end

    def exist_libs(spec_dir)
      Dir.glob("#{spec_dir}/lib/").inject([]){|acc, lib_file|
        if File.directory?(lib_file) && lib_file =~ /\/jasmine$|\/jasmine-.*$/
          Dir.glob(lib_file).each{|file|
            acc << file if file =~ /jasmine\.js|jasmine-html\.js/
          }
        end
        acc
      }
    end

    def run_phantomjs
      Phantomjs.run("#{current_dir}/#{RUN_JASMINE_SCRIPT}", "#{@config.spec_dir}/#{SPEC_RUNNER_HTML_NAME}")
    end

    def current_dir
      @current_dir ||= File.dirname(__FILE__)
    end
  end
end
