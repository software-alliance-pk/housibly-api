module SubAdminHelper
  def show_sub_admin_message(alert,name)
    if alert.is_a?(Array)
      alert&.find { |item| item&.include?(name) }
    else
      nil  # Handle the case where alert is a string or another data type
    end
  end
end
