module SubAdminHelper
  def show_sub_admin_message(alert,name)
    if alert.is_a?(Array)
      alert&.select { |item| item&.include?(name) }&.first
    else
      nil  # Handle the case where alert is a string or another data type
    end
  end
end
