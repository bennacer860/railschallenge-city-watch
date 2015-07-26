class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.text :code
      t.integer :fire_severity
      t.integer :police_severity
      t.integer :medical_severity
      t.integer :resolved_at
      t.integer :emergency_code
      t.boolean :full_response, default: true

      t.timestamps null: false
    end
  end
end
