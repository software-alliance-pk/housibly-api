class JobList < ApplicationRecord
	has_paper_trail
	validates :title, presence: true
end
