class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.references :company, index: true
      t.date :created
      t.date :last_updated

      t.timestamps
    end
  end
end
