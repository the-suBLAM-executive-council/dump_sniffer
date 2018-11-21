module DumpSniffer
  class CLI
    def initialize(args: nil)
      @args = args
      @dump_file = args.last
    end

    def run
      if args.first == '-s'
        extract_schema_from_dump(dump_file)
      elsif args.first == '-t'
        extract_table_names_from_dump(dump_file).join("\n")
      else
        raise "Unknown options"
      end
    end

    private

    attr_reader :args, :dump_file

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
