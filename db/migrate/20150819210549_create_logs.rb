class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :order_number
      t.string :provider
      t.integer :cost
      t.datetime :purchase_time

      t.timestamps null: false
    end
  end
end
