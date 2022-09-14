class CreateJobLists < ActiveRecord::Migration[6.1]
  def change
    create_table :job_lists do |t|
      t.string :title

      t.timestamps
    end
  end
end
