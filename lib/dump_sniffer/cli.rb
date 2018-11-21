module DumpSniffer
  class CLI
    def initialize(args: nil)
      @args = args
      @dump_file = args.last
    end

    def run
      extract_table_names_from_dump(dump_file).join("\n") + "\n"
    end

    private

    attr_reader :dump_file

    def extract_table_names_from_dump(dump_file)
      create_statements = File.readlines(dump_file).grep(/CREATE TABLE `.*?`/i)
      statements = create_statements.map do |statement|
        statement.sub(/CREATE TABLE `(.*?)`.*$/, '\1').chomp
      end
    end
  end
end
