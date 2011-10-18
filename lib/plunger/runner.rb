require 'optparse'

module Plunger
  class Runner
    def initialize(argv)
      @argv = argv
    end

    def run!
      @parser = OptionParser.new do |o|
        o.banner = "Usage: plunger [options] #{Command.names.join('|')}"

        o.separator ""
        o.separator "Commands:"

        o.separator ""
        Command.classes.each do |klass|
          o.separator "    %-20s %s" % [klass.command, klass.description]
        end

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
      Command.run(@command) or abort
    end

  end
end
