require 'optparse'

module Plunger
  class Runner
    def initialize(argv)
      @argv = argv
      @options = {}
    end

    def run!
      @parser = OptionParser.new do |o|
        o.banner = "Usage: plunger #{Command.names.join('|')} [options]"

        o.separator ""
        o.separator "Commands:"

        o.separator ""
        Command.classes.each do |klass|
          o.separator "    %-20s %s" % [klass.command, klass.description]
        end

        o.separator ""
        o.separator "Push options:"
        o.on("--initial REVISION", "Initial changeset revision.") { |v| @options[:initial] = v }
        o.on("--final REVISION", "Final changeset revision.")     { |v| @options[:final]   = v }
        o.on("--issue NUMBER", "Issue number to which to add. Defaults to new issue.") { |v| @options[:issue] = v }

        o.separator ""
        o.separator "Common options:"
        o.on_tail("-h", "--help", "Show this message") { puts o; exit }
        o.on_tail('-v', '--version', "Show version")   { puts Plunger::VERSION; exit }
      end

      begin
        @parser.parse!(@argv)
      rescue OptionParser::InvalidOption => e
        abort e.message
      end

      @command = @argv.shift

      unless Command.names.include?(@command) 
        abort "Unknown command #{@command.inspect}"
      end

      Command.autorun
      Command.run(@command, @options) or abort
    end

  end
end
