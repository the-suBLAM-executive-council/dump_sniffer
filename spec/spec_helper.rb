$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dump_sniffer'

def project_root_path
  File.dirname(__FILE__) + '/fixtures/'
end

def test_fixture_path(fname)
  project_root_path + fname
end
