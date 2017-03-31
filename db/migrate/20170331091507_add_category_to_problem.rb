class AddCategoryToProblem < ActiveRecord::Migration[5.0]
  def change
    change_table :problems do |t|
      t.integer :category, default: 1
    end
  end
end
