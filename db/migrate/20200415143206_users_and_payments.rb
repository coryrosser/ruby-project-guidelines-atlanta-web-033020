class UsersAndPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name 
      t.string :email 
      t.integer :balance
    end
  end
end
