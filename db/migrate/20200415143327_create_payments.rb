class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.timestamps
      t.integer :amount 
      t.belongs_to :user
      t.belongs_to :recipient_user
      t.index [:user_id, :recipient_user_id]
    end
  end
end
