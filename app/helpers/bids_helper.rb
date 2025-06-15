module BidsHelper
  def calculate_linehaul_plus_fuelsurcharge(miles, rate, fsch_percent, fuel_included = false)
    line_haul = PricingMatrix.line_haul_for_miles(miles, rate, fuel_included: false)
    
    if fuel_included
      calculate_fuelsurcharge(line_haul, fsch_percent)
    else
      line_haul
    end
  end

  def calculate_fuelsurcharge(line_haul, fsch_percent)
    ((fsch_percent.to_f / 100) * line_haul).round(2)
  end
end
