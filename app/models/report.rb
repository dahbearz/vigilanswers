class Report < ActiveRecord::Base
  belongs_to :category
  belongs_to :location
  
  validates_presence_of :title, :location_id
  
  def calculate_score
    return (@vote - 1) / (refresh_hour_age + 2)**(1.8)
  end

  def self.most_relavant(params)
    list = scoped
    list = list.where("title like ?", params[:title])
    list = list.where("location_id IN (:location)", :location => Location.near([params[:lat],params[:lon]],params[:range]))

    list.sort_by { |a,b| a.calculate_score <=> b.calculate_score}

    return list
  end

  def refresh_hour_age
    @report_hour_age =  (self.updated_at - self.created_at) * 3600
  end
end
