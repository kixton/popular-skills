class ChangeDateFormatInJobs < ActiveRecord::Migration
  def change
    change_column :jobs, :last_updated, :datetime
    change_column :jobs, :created, :datetime
  end
end
