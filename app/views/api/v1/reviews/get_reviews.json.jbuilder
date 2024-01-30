json.count @review_count
json.reviews @reviews do |review|
	json.partial! 'review', review: review
end
