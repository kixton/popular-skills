class CreateCompensations < ActiveRecord::Migration
  def change
    create_table :compensations do |t|
      t.references :job, index: true
      t.integer :salary_min
      t.integer :salary_max
      t.float :equity_min
      t.float :equity_max

      t.timestamps
    end
  end
end
