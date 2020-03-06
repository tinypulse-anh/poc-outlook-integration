class CreateChangeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :change_logs do |t|
      t.belongs_to :subscription, index: true
      t.string :event_id
      t.string :change_type
      t.timestamps null: false
    end
  end
end
