class Responder < ActiveRecord::Base
  self.inheritance_column = :_type
  belongs_to :emergency, foreign_key: "emergency_code"

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: 1..5, message: 'is not included in the list' }
  scope :available, -> { where(emergency_code: nil) }
  scope :on_duty,   -> { where(on_duty: true) }
  scope :by_type,   -> (type = nil) { where(type: type)  }

  def assign_emergency_code(emergency_code)
    self.update_attribute(:emergency_code, emergency_code)
  end

  #
  # Returns an array of the capacity of:
  # - All responders of the type
  # - Responders of the type that have not been assigned an emergency code
  # - Responders of the type that are on duty
  # - Responders of the type that have not been assigned an emergency code and
  #   are on duty
  #

  def self.show_capacity_by_type(type)
    [
      Responder.by_type(type).sum(:capacity),
      Responder.by_type(type).available.sum(:capacity),
      Responder.by_type(type).on_duty.sum(:capacity),
      Responder.by_type(type).available.on_duty.sum(:capacity)
    ]
  end

  def self.show_capacity
    types = [ "Fire" ,"Police" ,"Medical" ]
    capacity_result = {}
    types.each do |type|
      capacity_result[type] = self.show_capacity_by_type(type)
    end
    return capacity_result
  end

end
