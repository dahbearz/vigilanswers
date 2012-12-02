class Report < ActiveRecord::Base
  # belongs_to :location
  
  validates_presence_of :title
  #, :location_id
  attr_accessible :title, :description, :address
  #,:location
  # accepts_nested_attributes_for :location
  has_and_belongs_to_many :categories
  #has_one :location

  def calculate_score
    return (@score - 1) / (refresh_hour_age + 2)**(1.8)
  end

  def self.most_relavant(params)
    list = scoped

    list = list.where("title like ?", params[:title]) if params[:title]
    #list = list.where("location_id IN (:location)", :location => Location.near([params[:lat],params[:lon]],params[:range],:order => :distance)) if params[:lat] && params[:lon]

    list = list.joins(:categories).where(
      categories_reports: {
        category_id: params[:category_id]
      }
    ) if params[:category_id]

    list = list.limit(params[:limit] || 15)
    list.sort_by { |a,b| a.calculate_score <=> b.calculate_score}

    return list
  end

  def refresh_hour_age
    @report_hour_age =  (self.updated_at - self.created_at) * 3600
  end
end
