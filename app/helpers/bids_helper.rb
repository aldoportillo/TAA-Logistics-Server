module BidsHelper
  def calculate_linehaul_plus_fuelsurcharge(miles, rate, fsch_percent)
    line_haul = calculate_line_haul(miles, rate)
    return calculate_fuelsurcharge(line_haul, fsch_percent)
  end

  def calculate_line_haul(miles, rate)
    return miles.to_f * rate.to_f
  end

  def calculate_fuelsurcharge(line_haul, fsch_percent)
    return ((fsch.to_f/100) * line_haul).round(2)
  end
end
