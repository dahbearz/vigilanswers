class Category < ActiveRecord::Base
  has_and_belongs_to_many :reports
  attr_accessible :name
end
