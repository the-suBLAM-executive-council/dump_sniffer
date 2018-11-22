require 'optparse'
require 'ostruct'

module DumpSniffer
  class CLI
    def initialize(args: [])
      @args = args
    end

    def run
      options = parse_commandline_opts

      return extract_schema_from_dump(options.dump_file) if options.extract_schema
      return extract_table_names_from_dump(options.dump_file).join("\n") if options.extract_table_names
    end

    private

    attr_reader :args

    def parse_commandline_opts
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

    def usage(opt_parser)
      puts opt_parser
      exit
    end

    def extract_table_names_from_dump(dump_file)
      create_statements = File.readlines(dump_file).grep(/CREATE TABLE `.*?`/i)
      create_statements.map do |statement|
        statement.sub(/CREATE TABLE `(.*?)`.*$/, '\1').chomp
      end
    end

    def extract_schema_from_dump(dump_file)
      File.read(dump_file)
        .scan(/^DROP TABLE .*?;|^CREATE TABLE.*?;/m)
        .join("\n\n")
    end
  end
end
