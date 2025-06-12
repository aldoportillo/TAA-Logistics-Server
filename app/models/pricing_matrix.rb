class PricingMatrix < ApplicationRecord
  validates :start_miles, :end_miles, presence: true, numericality: { only_integer: true }
  validate :end_miles_greater_than_start_miles
  validate :no_overlapping_ranges

  private

  def end_miles_greater_than_start_miles
    return if start_miles.blank? || end_miles.blank?
    
    if start_miles >= end_miles
      errors.add(:end_miles, "must be greater than start miles")
    end
  end

  def no_overlapping_ranges
    return if start_miles.blank? || end_miles.blank?

    overlapping = PricingMatrix.where.not(id: id).where(
      '(start_miles <= ? AND end_miles >= ?) OR (start_miles <= ? AND end_miles >= ?) OR (start_miles >= ? AND end_miles <= ?)',
      end_miles, start_miles,  # Case 1: New range overlaps with existing range's start
      start_miles, end_miles,  # Case 2: New range overlaps with existing range's end
      start_miles, end_miles   # Case 3: New range is completely within existing range
    )

    if overlapping.exists?
      errors.add(:base, "This mileage range overlaps with an existing range")
    end
  end
end
