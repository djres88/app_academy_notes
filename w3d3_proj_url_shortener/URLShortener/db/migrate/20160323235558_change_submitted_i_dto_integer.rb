class ChangeSubmittedIDtoInteger < ActiveRecord::Migration
  def change
    change_column :shortened_urls, :submitter_id, :integer, :null => false
  end
end
