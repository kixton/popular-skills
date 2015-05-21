class CreateJobJobroles < ActiveRecord::Migration
  def change
    create_table :job_jobroles do |t|
      t.references :job, index: true
      t.references :jobrole, index: true

      t.timestamps
    end
  end
end
