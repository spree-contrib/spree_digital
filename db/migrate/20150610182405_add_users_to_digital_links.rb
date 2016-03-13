class AddUsersToDigitalLinks < ActiveRecord::Migration
  def change
    add_column :spree_digital_links, :user_id, :integer
  end
end
