class ReportsController < ApplicationController
  def index
  end

  def show
    @reports = Report.most_relavant(params)
  end
end
