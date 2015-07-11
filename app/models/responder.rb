class Responder < ActiveRecord::Base
  self.inheritance_column = :_type
  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: 1..5, message: 'is not included in the list' }
end
