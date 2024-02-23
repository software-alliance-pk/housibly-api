json.array! @bookmarks do |bookmark|
  json.partial! 'bookmark', bookmark: bookmark
end
