class Report < Authlogic::Session::Base

  def calculate_score(votes, item_hour_age)
    return (votes - 1) / (item_hour_age + 2)**(1.8)
  end
end
