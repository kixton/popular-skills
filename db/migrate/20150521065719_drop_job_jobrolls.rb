class DropJobJobrolls < ActiveRecord::Migration
  def change
    drop_table :job_jobrolls
  end
end
