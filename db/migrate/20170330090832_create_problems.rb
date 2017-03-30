class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.references :workshop, foreign_key: true, null: false
      t.string :name, null: false
      t.text :content, null: false
      t.string :solution, null: false
      t.integer :kind, null: false, default: 1

      t.timestamps
    end
  end
end
