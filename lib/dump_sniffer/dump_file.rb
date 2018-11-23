module DumpSniffer
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
end
