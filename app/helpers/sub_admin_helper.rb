module SubAdminHelper
  def show_sub_admin_message(alert,name)
    alert.select{ |item| item.include?(name) }.first
  end
end