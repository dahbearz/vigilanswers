class ReportsController < ApplicationController
  respond_to :json,:html
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      flash[:notice] = "Event reported successfully."
      redirect_to report_path(@report)
    else
      flash[:error] = "Unable to make event."
      render :action => :new
    end
  end

  def index
    @reports = Report.most_relavant(params)
    respond_with @reports
  end

  def show
    @report = Report.find(params[:id])
    respond_with @report
  end


end
