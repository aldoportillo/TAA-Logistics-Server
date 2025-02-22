module BidsHelper
  def calculate_linehaul_plus_fuelsurcharge(miles, rate, fsch)
    return ((1 + fsch.to_f/100) * calculate_line_haul(miles, rate)).round(2)
  end

  def calculate_line_haul(miles, rate)
    return miles.to_f * rate.to_f
  end
end
