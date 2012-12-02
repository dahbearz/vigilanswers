class ReportsController < ApplicationController
  respond_to :json,:html
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      flash[:notice] = "Event reported successfully."
      coords = {:latitude => @report.latitude, :longitude => @report.longitude}
      AlertMailer.alert_email(@report).deliver if User.near(coords.values, 20).present?
      AlertMailer.sms_send(@report).deliver if User.near(coords.values, 20).present?
      redirect_to report_path(@report)
    else
      flash[:error] = "Unable to make event."
      render :action => :new
    end
  end

  def index
    loc = Geocoder.search(request.remote_ip)[0]
    @coords = {latitude: loc.latitude, longitude: loc.longitude}
    @reports = Report.most_relavant(params, @coords)
    respond_with @reports
  end

  def show
    @report = Report.find(params[:id])
    respond_with @report
  end

  def update
    @report = Report.find(params[:report][:id])
    @report.update_attributes(params[:report])
    respond_with @report
  end

  def increment_count
    @report = Report.find(params[:report_id])
    @report.score = @report.score + 1
    @report.save
    respond_with @report
  end

end
