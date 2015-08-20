class AddEstimateToLog < ActiveRecord::Migration
  def change
    add_column :logs, :estimate, :string
  end
end
