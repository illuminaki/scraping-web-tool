class CreateRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :registers do |t|
      t.text :url
      t.string :title
      t.string :description
      t.string :emails
      t.string :phones
      t.string :social_networks
      t.string :website_url
      t.string :address
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
