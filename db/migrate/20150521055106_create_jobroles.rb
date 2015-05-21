class CreateJobroles < ActiveRecord::Migration
  def change
    create_table :jobroles do |t|
      t.integer :angellist_id
      t.string :name

      t.timestamps
    end
  end
end
