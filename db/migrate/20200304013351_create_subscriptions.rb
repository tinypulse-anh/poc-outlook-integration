class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.string :external_id
      t.datetime :expired_at
      t.timestamps null: false
    end
  end
end
