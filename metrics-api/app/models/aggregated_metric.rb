class AggregatedMetric < ApplicationRecord
    enum period: { minute: 0, hour: 1, day: 2 }
  
    validates :name, :period, :timestamp, :average_value, :min_value, :max_value, :total_value, :count, presence: true
  end