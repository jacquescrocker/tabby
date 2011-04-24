module Tabby
  class Runner
    TABBYDIR = File.expand_path("~/.tabby")

    # Project name, should be the filename in ~/.tabby.
    attr_reader :project

    def initialize(argv)
      @project = argv[0]
      @klass   = @project.split("_").map { |p| p.capitalize }.join.to_sym
    end

    # Loads the environment file (from ~/.tabby), finds the class
    # which matches the filename and +call+s it.
    #
    def start
      require File.join(TABBYDIR, "#{@project}.rb")
      ObjectSpace.class.const_get(@klass).new.call

    rescue LoadError
      puts "=> ERROR: Project (#{TABBYDIR}/#{@project}.rb) does not exist."

    rescue NameError
      puts "=> ERROR: Project filename/classname mismatch."
      puts "   Filename is:          #{@project}.rb"
      puts "   Classname should be:  #{@klass}"
    end
  end
end
