module RatesHelper
  def rate_link(rateable, rate)
    link_to rate, member_rate_path(:type=>rateable.class.name,:id=>rateable.id,:rate=>rate)
  end
end
