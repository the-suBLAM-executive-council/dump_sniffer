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
        <<-EOS
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
end
