json.array! @support_closers do |support_closer|
  json.partial! 'user', user: support_closer
end
