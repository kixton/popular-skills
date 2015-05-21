class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.references :company, index: true
      t.string :thumb_url

      t.timestamps
    end
  end
end
