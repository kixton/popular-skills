class AddJobtypeToJobs2 < ActiveRecord::Migration
  def change
    add_reference :jobs, :jobtype, index: true
  end
end
