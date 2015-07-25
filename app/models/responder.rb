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

  def self.show_capacity
    group_by_type = Responder.all.to_a.group_by{|e| e[:type]}
    capacities = {}
    group_by_type.keys.each{|key|  capacities[key] = [
      group_by_type[key].map{|r| r.capacity}.inject(:+),
      group_by_type[key].select{|r| r.emergency_code.nil?}.map{|r| r.capacity}.inject(:+),
      group_by_type[key].select{|r| r.on_duty}.map{|r| r.capacity}.inject(:+),
      group_by_type[key].select{|r| r.on_duty && r.emergency_code.nil?}.map{|r| r.capacity}.inject(:+) ]}
    capacities
  end

end
