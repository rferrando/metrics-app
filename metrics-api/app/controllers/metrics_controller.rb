class MetricsController < ActionController::Base

  def index
    @metrics = Metric.all
    render json:  @metrics
  end

  def create
    @metric = Metric.new(metric_params)
    if @metric.save
      render json: @metric, status: :created
    else
      render json: @metric.errors, status: :unprocessable_entity
    end
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value)
  end
end
