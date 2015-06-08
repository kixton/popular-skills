class DropTableJobtypes < ActiveRecord::Migration
  def change
    drop_table :jobtypes
  end
end
