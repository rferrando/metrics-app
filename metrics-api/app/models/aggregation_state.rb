class AggregationState < ApplicationRecord
  enum period: { minute: 0, hour: 1, day: 2 }

  validates :name, :period, :last_aggregated_at, presence: true
end