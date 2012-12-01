class ReportsController < ApplicationController
  def index
    @reports = Report.most_relavant(params)
  end

  def show
  end
end
