class AddPackageTypeToPackage < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :package_type, :string
  end
end
