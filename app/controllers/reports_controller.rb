class ReportsController < ApplicationController

  def index
    render :text => 'hi'
  end

  def show
    @reports = Report.most_relavant(params)
  end
end
