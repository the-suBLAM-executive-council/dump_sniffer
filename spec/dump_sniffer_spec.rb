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

  def expect_usage_and_exit(&block)
    expect {
      expect {
        block.call
      }.to raise_error(SystemExit)
    }.to output(/Usage/).to_stdout
  end

  it 'prints the usage and exits when no dump file is given' do
    cli = DumpSniffer::CLI.new(args: [])
    expect_usage_and_exit { cli.run }
  end

  it 'prints the usage and exits when the given dump file doesnt exist' do
    cli = DumpSniffer::CLI.new(args: ['/doesnt/exist.sql'])
    expect_usage_and_exit { cli.run }
  end

  it 'prints the usage and exits when unknown options are given' do
    cli = DumpSniffer::CLI.new(args: ['--some --unknown --options'])
    expect_usage_and_exit { cli.run }
  end
end
