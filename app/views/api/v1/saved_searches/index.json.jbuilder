json.array! @saved_searches do |saved_search|
  json.partial! 'saved_search', saved_search: saved_search
end
