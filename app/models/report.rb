class Report < Authlogic::Session::Base
  belongs_to :category
  has_one :location
  
  def calculate_score
    return (@vote - 1) / (@report_hour_age + 2)**(1.8)
  end

  def most_relavant(params)
    list = scoped
    list = list.where("title like ?", params[:title])
    list = list.where("location_id IN (:location)", :location => Location.near([params[:lat],params[:lon]],params[:range],:order => :distance))

    list.each do |report|
      report.calculate_score
    end

    return list
  end
end
