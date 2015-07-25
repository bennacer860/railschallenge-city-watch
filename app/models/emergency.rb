class Emergency < ActiveRecord::Base
  self.primary_key = 'code'
  has_many  :responders, :foreign_key => 'emergency_code'
  validates :code, presence: true, uniqueness: true
  validates :police_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fire_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  RESPONDER_TYPE = { :fire_severity => "Fire", :medical_severity => "Medical", :police_severity => "Police" }
  before_create :dispatch

  def resolved?
    !resolved_at.nil?
  end

  def full_message

  end

  def dispatch
    RESPONDER_TYPE.keys.each{|key|
      #find a responder on duty
    }
  end

end
