class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.timestamp :logged_in_at

      t.timestamps
    end
  end
end
