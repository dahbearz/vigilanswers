class Report < ActiveRecord::Base
  # belongs_to :location

  validates_presence_of :title
  #, :location_id
  attr_accessible :title, :description, :address, :score
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

  def self.most_relavant(params, coords)
    unless coords[:latitude] && coords[:latitude] != 0
      coords[:latitude] = 33.785645599999995
    end
    unless coords[:longitude] && coords[:longitude] != 0
      coords[:longitude] = -84.394973
    end
    coords.merge!({
      latitude: params[:latitude],
      longitude: params[:longitude]
    }) if params[:latitude] && params[:longitude]
    list = scoped

    list = list.where("lower(title) like lower(?)", params[:title]) if params[:title]
    list = list.near(coords.values, params[:range] || 20)

    list = list.joins(:categories).where(
      categories_reports: {
        category_id: params[:category_id]
      }
    ) if params[:category_id]

    #return (self.score) / (refresh_hour_age + 2)**(1.8)
    list = list.limit(params[:limit] || 15)
    if Rails.env.development?
      list.order_values.prepend "- score / ((strftime('%s','now' - created_at) * 3600) << 2)"
    else
      list.order_values.prepend "- score / pow((extract (epoch from 'now' - created_at) * 3600), 2)"
    end

    #list.sort_by! { |obj| - obj.calculate_score }

    return list
  end

  def refresh_hour_age
    self.report_hour_age = (Time.now - self.created_at) * 3600
    self.save
    return self.report_hour_age
  end
end
