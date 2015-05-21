class RemoveJobtypeFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :jobtype_id
  end
end
