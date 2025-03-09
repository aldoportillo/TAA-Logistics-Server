module BidsHelper
  def calculate_linehaul_plus_fuelsurcharge(miles, rate, fsch_percent)
    line_haul = calculate_line_haul(miles, rate)
    return calculate_fuelsurcharge(line_haul, fsch_percent)
  end

  def calculate_line_haul(miles, rate)
    miles = miles.to_f
    if miles > 400
      (miles * rate.to_f).round(2)
    else
      case miles
      when 0...20
        281.95
      when 20...40
        281.95
      when 40...60
        300.75
      when 60...80
        319.55
      when 80...90
        338.35
      when 90...100
        357.14
      when 100...120
        375.94
      when 120...140
        413.53
      when 140...160
        451.13
      when 160...200
        526.32
      when 200...250
        563.91
      when 250...300
        639.10
      when 300...360
        714.29
      when 360...380
        751.88
      when 380...400
        789.47
      else
        0.0
      end
    end
  end

  def calculate_fuelsurcharge(line_haul, fsch_percent)
    return ((fsch.to_f/100) * line_haul).round(2)
  end
end
