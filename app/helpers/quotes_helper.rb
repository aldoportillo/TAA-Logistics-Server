module QuotesHelper
  def calculate_line_haul(miles, rate)
    PricingMatrix.line_haul_for_miles(miles, rate, fuel_included: false)
  end

  def calculate_line_haul_including_fuel(miles, rate)
    PricingMatrix.line_haul_for_miles(miles, rate, fuel_included: true)
  end

  def calculate_fuel_surcharge(line_haul, fsch_percent)
    ((fsch_percent.to_f / 100) * line_haul).round(2)
  end
end
