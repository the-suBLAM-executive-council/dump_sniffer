module DumpSniffer
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
