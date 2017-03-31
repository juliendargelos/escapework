class RemoveContentNullConstraintFromProblem < ActiveRecord::Migration[5.0]
  def change
    change_column :problems, :content, :text, null: true
  end
end
