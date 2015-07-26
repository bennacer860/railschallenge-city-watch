class EmergencySerializer < ActiveModel::Serializer
  attributes :code, :fire_severity, :police_severity, :medical_severity, :full_response
  has_many :responders

  def responders
    object.responders.pluck(:name)
  end
  
end
