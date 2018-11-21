require 'spec_helper'

describe DumpSniffer do
  it 'has a version number' do
    expect(DumpSniffer::VERSION).not_to be nil
  end

  context 'when run with the "-t" option' do
    it 'prints the tables in the given dump file' do
      expect(
        DumpSniffer::CLI.new(
          args: ['-t', test_fixture_path('simple.sql')]
        ).run
      ).to eq(
        <<~EOS.chomp
          customers
          employees
          offices
          orderdetails
          orders
          payments
          productlines
          products
        EOS
      )
    end
  end

  context 'when run with the "-s" option' do
    it 'prints just the schema for the given dump file' do
      expect(
        DumpSniffer::CLI.new(
          args: ['-s', test_fixture_path('single_table_with_data.sql')]
        ).run
      ).to eq(
        <<~EOS.chomp
          DROP TABLE IF EXISTS `customers`;

          CREATE TABLE `customers` (
            `customerNumber` int(11) NOT NULL,
            `customerName` varchar(50) NOT NULL,
          ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
        EOS
      )
    end
  end
end
