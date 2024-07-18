class MetricsController < ApplicationController
  before_action :validate_params, only: [:create]
  
  def initialize(repository = MetricRepository.new)
    @repo = repository
  end

  def create
    metric = @repo.create(metric_params)
    render json: metric, status: :created
  end

  def generate_random_data
    num_metrics = params[:num_metrics].to_i
    random_metrics = Metrics::GenerateRandomData.new(repository: @repo).call(num_metrics)
    render json: random_metrics
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :timestamp)
  end
    
    def validate_params
        raise ValidationError.new("Metric name can't be blank") if metric_params[:name].blank?
        raise ValidationError.new("Metric value can't be blank" ) if metric_params[:value].blank?
    end
end
