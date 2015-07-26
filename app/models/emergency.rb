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
    RESPONDER_TYPE.each do |key,value|
      # find a responder on duty and available that can handle the emergency on his own
      #post '/emergencies/', emergency: { code: 'E-00000001', fire_severity: 3, police_severity: 0, medical_severity: 0  }
      responder = Responder.where("type = ? and capacity = ?", value, self.send(key))
      # see if we ahve an exact match
      if responder.count == 1
        self.responders << responder
      else
        #binding.pry
        # if there is no exact match add resources until it is enough for the emergency severity
        add_resource(value,self.send(key))
      end
    end
  end

  def add_resource(type,severity)
    responders_by_type = Responder.by_type(type).on_duty.available.order(capacity: :desc)
    responder_severity_sum = 0
    responder_list = []
    responders_by_type.each do |responder|
      if (responder_severity_sum < severity)
        responder_severity_sum += responder.capacity
        # puts "type : #{type} - severity : #{severity} - responder  #{responder.name} : #{responder.capacity}"
        # puts "responder_severity_sum #{responder_severity_sum}"
        self.responders << responder
      end
    end
  end

end
