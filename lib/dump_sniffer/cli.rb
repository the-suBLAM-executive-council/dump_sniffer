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

  class DumpFile
    attr_reader :fname

    def initialize(fname)
      @fname = fname
    end

    def table_names
      results = []
      File.foreach(fname) do |line|
        next unless line =~ /CREATE TABLE `.*?`/i

        results << line.sub(/CREATE TABLE `(.*?)`.*$/, '\1').chomp
      end

      results
    end

    def schema
      File.read(fname)
        .scan(/^DROP TABLE .*?;|^CREATE TABLE.*?;/m)
        .join("\n\n")
    end
  end

  class CliArgParser
    def initialize(args)
      @args = args
    end

    def perform
      options = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: dump_sniffer [OPTIONS] dump_file.sql"

        opts.on('-s', '--schema-only', 'Extract the schema only. The table DROPs and CREATEs. No data') do
          options.extract_schema = true
        end

        opts.on('-t', '--table-names', 'List the table names in the dump') do
          options.extract_table_names = true
        end

        opts.on('-h', '--help', 'Prints this help') do
          usage(opts)
        end
      end

      begin
        opt_parser.parse!(args)
      rescue OptionParser::InvalidOption
        usage(opt_parser)
      end

      options.dump_file = args.first
      unless File.exists?(options.dump_file.to_s)
        usage(opt_parser)
      end

      options
    end

    private

    attr_reader :args

    def usage(opt_parser)
      puts opt_parser
      exit
    end
  end

end
