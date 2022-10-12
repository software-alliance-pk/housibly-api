module UserProfileHelper
  def get_condo_property_list(id)
    User.find_by_id(id)&.properties&.condo&.order(created_at: :desc)
  end

  def get_vacant_land_property_list(id)
    User.find_by_id(id)&.properties&.vacant_land&.order(created_at: :desc)
  end

  def get_house_property_list(id)
    User.find_by_id(id)&.properties&.house&.order(created_at: :desc)
  end
end