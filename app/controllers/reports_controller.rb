class ReportsController < ApplicationController
  respond_to :json,:html
  def index
    @reports = Report.most_relavant(params)
    respond_with @reports
  end

  def show
  end
end
