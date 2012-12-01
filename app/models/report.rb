class Report < Authlogic::Session::Base
  belongs_to :category
  
  def calculate_score(votes, item_hour_age)
    return (votes - 1) / (item_hour_age + 2)**(1.8)
  end
end
