class AddAdminToPage < ActiveRecord::Migration[6.1]
  def change
    add_reference :pages, :admin, null: false, foreign_key: true
  end
end
