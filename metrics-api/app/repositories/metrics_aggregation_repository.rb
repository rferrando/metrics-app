
class MetricsAggregationRepository

  def initialize(client: ActiveRecord::Base.connection)
    @client = client
  end  

  def find_by_name_and_period_and_date_range(name, period, start_date, end_date)
    aggregate_sql = <<-SQL
      SELECT
        *
      FROM aggregated_metrics
      WHERE name = '#{name}' AND period = '#{periods[period]}'
      AND timestamp >= '#{start_date}' and timestamp <= '#{end_date}'
      ORDER BY timestamp ASC
    SQL

    @client.execute(aggregate_sql)  
  end

  def periods
    AggregatedMetric.periods
  end  

  def upsert_all_aggregated_metric(data)
    # AggregatedMetric.upsert_all(data, unique_by: [:name, :period, :timestamp])
    # upsert_all is efficient for bulk inserts/updates because it bundles the operations into a single 
    # SQL query.That method is designed for direct, bulk operations on the database, bypassing ActiveRecord callbacks 
    #that automatically handle timestamps, such as created_at and updated_at timestamps, so these must be managed 
    # manually. Optimization: generation of direct SQL that runs on the database without going through ActiveRecord 
    # instance methods to handle timestamps properly.

    #Add timestamps
    current_time = Time.current
    values = data.map do |row|
      row['updated_at'] = current_time
      row['created_at'] = current_time
      row['timestamp'] = row['timestamp'].send("end_of_#{row['period']}")
      row['period'] = periods[row['period']] 
      "(#{row.values.map { |value| ActiveRecord::Base.connection.quote(value) }.join(', ')})"
    end.join(', ')

    columns_with_updated_at = data.first.keys.map(&:to_s) + ['updated_at']
    columns_with_timestamps = columns_with_updated_at + ['created_at']
    columns = columns_with_timestamps.join(', ')

    #DO UPDATE SET updates only non-created_at columns when there is a conflict, 
    #ensuring that created_at is not overwritten.
    conflict_target = [:name, :period, :timestamp] 
    updates = columns_with_updated_at.map { |k| "#{k} = EXCLUDED.#{k}" }.join(', ')

    sql = <<-SQL
      INSERT INTO aggregated_metrics (#{columns})
      VALUES #{values}
      ON CONFLICT (#{conflict_target.join(', ')})
      DO UPDATE SET #{updates}
    SQL

    @client.execute(sql)
  end
end
  