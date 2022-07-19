json.tickets @tickets do |ticket|
  json.ticket ticket
  json.image ticket.image.attached? ? rails_blob_url(ticket.image) : ""
end
