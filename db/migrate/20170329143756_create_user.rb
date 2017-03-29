class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.boolean :admin, default: false
    end
  end
end
