module Tabby
  class Base
    class << self
      attr_reader :_basedir
      attr_reader :_tabs
    end

    # Sets the project root directory.
    #
    # Parameters:
    #    dir  Project's root directory path
    #
    def self.basedir(dir)
      @_basedir = dir
    end

    # define a tab
    def self.tab(name, &block)
      @_tabs ||= []
      @_tabs << [name, block]
    end

    # List of commands for the current tab to execute.
    attr_accessor :commands

    # Title of the current tab being created.
    attr_accessor :title

    # Rendered AppleScript source to be saved to a tempfile.
    attr_accessor :template

    def initialize
      @commands = []
    end

    # Queue a command to be executed when the tab gets created.
    #
    # Parameters:
    #   command   bash/zsh/etc command to be executed
    #
    def exec(command)
      @commands << %{write text "#{command}"}
    end

    # Call each instance method and create a tab for each one.
    # Method names become tab titles, with underscores replaced
    # with spaces.
    #
    def call
      self.class.instance_methods(false).sort.each do |method|
        @commands = []
        @title    = method.gsub("_", " ")
        send(method)
        create_tab
      end

      self.class._tabs.each do |title, block|
        @commands = []
        @title    = title
        self.instance_exec(&block)
        create_tab
      end
    end

    # Project's base directory. Each tab +cd+'s into this
    # directory before executing commands.
    #
    def basedir
      self.class._basedir
    end

  private

    def create_tab
      tempfile = Tempfile.new("tabby-#{@title}")
      tempfile.write(render_script)
      tempfile.close
      system("osascript #{tempfile.path}")
    end

    def render_script
      osapath   = ROOT.join("script/tabby.osa.erb")
      template  = ERB.new(File.read(osapath))
      commands  = @commands.join("\n")
      @template = template.result(binding)
    end
  end
end
