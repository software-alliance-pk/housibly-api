class AddSupportCloserIdToReview < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews,:support_closer_id, :integer, index: true
    # add_reference :reviews, :users, column: :support_closer_id
  end
end
