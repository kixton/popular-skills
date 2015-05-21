class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_url
      t.string :angellist_url

      t.timestamps
    end
  end
end
