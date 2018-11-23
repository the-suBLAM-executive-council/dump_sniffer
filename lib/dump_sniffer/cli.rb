require 'optparse'
require 'ostruct'

module DumpSniffer
  class CLI
    def initialize(args: [])
      @args = args
    end

    def run
      options = CliArgParser.new(args).perform
      dump_file = DumpFile.new(options.dump_file)

      return dump_file.schema if options.extract_schema
      return dump_file.table_names.join("\n") if options.extract_table_names
    end

    private

    attr_reader :args
  end
end
