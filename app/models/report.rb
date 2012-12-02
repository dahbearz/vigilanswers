class Report < ActiveRecord::Base
  # belongs_to :location

  validates_presence_of :title
  #, :location_id
  attr_accessible :title, :description, :address
  #,:location
  # accepts_nested_attributes_for :location
  has_and_belongs_to_many :categories
  #has_one :location

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  attr_accessible :latitude, :longitude, :address

  validates_presence_of :address
  after_validation :geocode, :reverse_geocode, :if => lambda{ |obj| obj.address_changed?}

  def calculate_score
    return (self.score) / (refresh_hour_age + 2)**(1.8)
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
    list.sort_by! { |obj| obj.score }

    return list.reverse!
  end

  def refresh_hour_age
    @report_hour_age =  (Time.now - self.created_at) * 3600
  end
end
