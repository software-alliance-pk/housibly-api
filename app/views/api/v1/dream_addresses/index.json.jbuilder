json.array! @dream_addresses do |address|
  json.partial! 'dream_address', address: address
end
