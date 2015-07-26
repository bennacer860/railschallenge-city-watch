class Emergency < ActiveRecord::Base
  self.primary_key = 'code'
  has_many  :responders, :foreign_key => 'emergency_code'
  validates :code, presence: true, uniqueness: true
  validates :police_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fire_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  RESPONDER_TYPE = { :fire_severity => "Fire", :medical_severity => "Medical", :police_severity => "Police" }
  before_create :dispatch
  before_save :resolve

  def resolve
    self.responders.clear 
  end

  def enough_resources?
    self.responders.sum(:capacity) >= (self.fire_severity + self.police_severity + self.medical_severity)
  end

  def full_response
    not_enough_ressorces_count = Emergency.all.select{|emergency| emergency.fully_responded}.count
    total_emergencies = Emergency.count
    [not_enough_ressorces_count,total_emergencies]
  end

  def dispatch
    RESPONDER_TYPE.each do |key,value|
      # find a responder on duty and available that can handle the emergency on his own
      responder = Responder.by_type(value).on_duty.available.where("capacity = ?", self.send(key))
      # see if we ahve an exact match
      if responder.count == 1
        self.responders << responder
      else
        # if there is no exact match add resources until it is enough for the emergency severity
        add_resource(value,self.send(key))
      end
    end
    self.fully_responded = true if self.enough_resources?
  end

  def add_resource(type,severity)
    responders_by_type = Responder.by_type(type).on_duty.available.order(capacity: :desc)
    responder_severity_sum = 0
    responder_list = []
    responders_by_type.each do |responder|
      if (responder_severity_sum < severity)
        responder_severity_sum += responder.capacity
        self.responders << responder
      end
    end
  end

  private

  def resolved?
    !resolved_at.nil?
  end

end
