class AddAngellistIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :angellist_id, :integer
  end
end
