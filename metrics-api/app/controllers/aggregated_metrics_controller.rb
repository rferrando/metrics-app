
class AggregatedMetricsController < ApplicationController
    def index
        @metrics = Metrics::Aggregate.new.call(params[:name], params[:period])
        render json: @metrics
    end
end
  