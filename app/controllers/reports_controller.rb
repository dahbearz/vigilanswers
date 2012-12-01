class ReportsController < ApplicationController
  def new
    @report = Report.new
  end
  
  def create
    report = @report
    if report.save
      flash[:notice] = "Event reported successfully."
      render :action => :show
    else
      flash[:error] = "Unable to make event."
      render :action => :new
    end
  end

  def index
    @reports = Report.most_relavant(params)
  end

  def show
  end
  
  
end
