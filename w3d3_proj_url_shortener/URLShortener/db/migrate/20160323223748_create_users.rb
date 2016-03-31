class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email

      t.timestamps
    end

    # add_index
    # null: false as validation for email
  end
end
