json.extract! bookmark, :id, :bookmark_type

if bookmark.bookmark_type == "user_bookmark"
  user = bookmark.bookmarked_user
  json.user do
    json.id user.id
    json.full_name user.full_name
    json.avatar user.avatar.attached? ? rails_blob_url(user.avatar) : ""
    json.average_rating user.support_closer_reviews.average(:rating).to_f

    json.professions user.professions.map(&:title)
  end
else
  json.property do
    json.extract! bookmark.property, :id, :title, :price, :bath_rooms, :bed_rooms
    json.image (rails_blob_url(bookmark.property.images.first) rescue "")
  end
end
