class AddImageToWorkshop < ActiveRecord::Migration[5.0]
    def change
      change_table :workshops do |t|
        t.attachment :image
      end
    end
end
