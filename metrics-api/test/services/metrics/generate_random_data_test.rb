require 'test_helper'

class GenerateRandomDataTest < ActiveSupport::TestCase
  test "should generate N random metrics" do
    num_metrics = 10
    assert_difference 'Metric.count', num_metrics do
    Metrics::GenerateRandomData.new.call(num_metrics)
    end
  end

  test "should generate at least one cpu metric" do
    Metrics::GenerateRandomData.new.call(100)
    assert Metric.where(name: 'cpu').exists?, "No CPU metrics generated"
  end

  test "should generate at least one mem metric" do
    Metrics::GenerateRandomData.new.call(100)
    assert Metric.where(name: 'mem').exists?, "No MEM metrics generated"
  end

  test "should generate at least one temp metric" do
    Metrics::GenerateRandomData.new.call(100)
    assert Metric.where(name: 'temp').exists?, "No TEMP metrics generated"
  end
end
