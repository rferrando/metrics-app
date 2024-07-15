class Metrics::GenerateRandomData
  METRIC_TYPES = {
    'cpu' => (0..100),
    'mem' => (512..32768),
    'temp' => (0..105)
  }.freeze

  def initialize(metric_repository: MetricRepository.new)
    @metric_repository = metric_repository
  end

  def call(num_metrics)
    num_metrics = num_metrics || 0
    num_metrics.times do
      @metric_repository.create(generate_random_metric)
    end
  end

  private

  def generate_random_metric
    metric_type = random_metric_type
    metric_timestamp = generate_random_timestamp
    {
      name: metric_type,
      value: random_value_for(metric_type),
      timestamp: metric_timestamp,
      minute_precision: metric_timestamp.beginning_of_minute,
      hour_precision: metric_timestamp.beginning_of_hour,
      day_precision: metric_timestamp.beginning_of_day
    }
  end

  def generate_random_timestamp
    now = Time.current
    one_week_ago = now - 1.week
    rand(one_week_ago..now)
  end

  def random_metric_type
    METRIC_TYPES.keys.sample
  end

  def random_value_for(type)
    range = METRIC_TYPES[type]
    rand(range)
  end
end
