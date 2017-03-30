class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :user, foreign_key: true, null: false
      t.references :problem, foreign_key: true, null: false
      t.string :content

      t.timestamps
    end
  end
end
