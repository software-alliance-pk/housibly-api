class Admin < ApplicationRecord
    include PgSearch::Model
     pg_search_scope :custom_search,
                  against: [:full_name, :email, :phone_number, :location, :status, :user_name],
                  using: {
                    tsearch: { prefix: true }
                  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :sub_admins, -> { where(admin_type: "sub_admin")}
  
  

  enum admin_type: {
    admin: 0,
    sub_admin: 1,
  }

   def self.to_csv
    CSV.generate(headers: true) do |csv|
        csv << self.attribute_names

        all.each do |record|
          csv << record.attributes.values
      end
    end
  end
end
