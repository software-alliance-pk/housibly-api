json.properties @bookmarks do |bookmark|
  if bookmark.property.present?
    json.property bookmark.property
  end
end
json.users @bookmarks do |bookmark|
  if !bookmark.property.present?
    json.user bookmark.user
  end
end