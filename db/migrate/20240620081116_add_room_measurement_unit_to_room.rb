class AddRoomMeasurementUnitToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :room_measurement_unit, :string
  end
end
