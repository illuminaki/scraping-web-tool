class CreateSentEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :sent_emails do |t|
      t.string :email
      t.string :subject
      t.text :body
      t.string :status
      t.string :message_id
      t.references :register, null: false, foreign_key: true

      t.timestamps
    end
  end
end
