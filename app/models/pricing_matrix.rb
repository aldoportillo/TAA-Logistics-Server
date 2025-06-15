class PricingMatrix < ApplicationRecord
  validates :start_miles, :end_miles, presence: true, numericality: { only_integer: true }
  validate :end_miles_greater_than_start_miles
  validate :no_overlapping_ranges

  def self.line_haul_for_miles(miles, rate, fuel_included: true)
    miles = miles.to_f
    max_end = PricingMatrix.maximum(:end_miles)
    if miles > max_end
      (miles * rate.to_f).round(2) #If miles exceed matrix
    else
      record = PricingMatrix.where('start_miles <= ? AND end_miles > ?', miles, miles).first
      return 0.0 unless record
      fuel_included ? record.line_haul_plus_29_5_fuel_surcharge : record.line_haul
    end
  end

  private

  def end_miles_greater_than_start_miles
    return if start_miles.blank? || end_miles.blank?
    
    if start_miles >= end_miles
      errors.add(:end_miles, "must be greater than start miles")
    end
  end

  # Inclusive/exclusive: [start_miles, end_miles)
  def no_overlapping_ranges
    return if start_miles.blank? || end_miles.blank?
    return if new_record? && PricingMatrix.count.zero?

    overlapping = PricingMatrix.where.not(id: id).where(
      'start_miles < ? AND end_miles > ?', end_miles, start_miles
    )

    if overlapping.exists?
      errors.add(:base, "This mileage range overlaps with an existing range")
    end
  end
end
