
class MetricRepository
  
  def create(attributes)
    begin
      metric = Metric.create!(attributes)
      {response: { status: 'success', data: metric }, status: :created}
    rescue ActiveRecord::RecordInvalid => e
      {response: { status: 'error', message: e.message, errors: e.record.errors.full_messages }, status: :unprocessable_entity}
    rescue StandardError => e
      {response: { status: 'error', message: 'An unexpected error occurred.' }, status: :internal_server_error}
    end
  end
  
  def names
    Metric.distinct.pluck(:name)
  end

  def minimum_time_registered_for_metric(name)
    Metric.where(name: name).minimum(:created_at)
  end

  def maximum_time_registered_for_metric(name)
    Metric.where(name: name).maximum(:created_at)
  end

  def calculate_aggregations_by_name_and_period_in_range(name, period, start_time, end_time)
    aggregate_sql = <<-SQL

    with time_ranges_to_process as (
      SELECT #{period}_precision as time_range
      from metrics  where name = '#{name}' 
        and created_at BETWEEN '#{start_time}' AND '#{end_time}'
        group by 1
    )
      SELECT
        '#{name}' as name,
        '#{period}' as period,
        m.#{period}_precision as timestamp,
        AVG(value) as average_value,
        MIN(value) as min_value,
        MAX(value) as max_value,
        SUM(value) as total_value,
        COUNT(*) as count
      FROM metrics m
      join time_ranges_to_process tr on tr.time_range = m.#{period}_precision
      WHERE name = '#{name}'
      GROUP BY name, m.#{period}_precision
    SQL

    ActiveRecord::Base.connection.execute(aggregate_sql)
  end
end
  