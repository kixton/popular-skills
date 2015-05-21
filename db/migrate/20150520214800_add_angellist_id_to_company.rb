class AddAngellistIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :angellist_id, :integer
  end
end
