module SchoolPinHelper
  def show_school_pin_message(alert,name)
    alert.select{ |item| item.include?(name) }.first
  end
end
