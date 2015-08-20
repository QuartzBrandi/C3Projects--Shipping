class AddClientNameToLog < ActiveRecord::Migration
  def change
    add_column :logs, :client_name, :string
  end
end
