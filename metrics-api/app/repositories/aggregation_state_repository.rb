class AggregationStateRepository
    def find_last_aggregated_at(name, period)
      AggregationState.find_or_initialize_by(name: name, period: period).last_aggregated_at
    end
  
    def update_last_aggregated_at(name, period, last_aggregated_at)
      state = AggregationState.find_or_initialize_by(name: name, period: period)
      state.update!(last_aggregated_at: last_aggregated_at)
    end
  end