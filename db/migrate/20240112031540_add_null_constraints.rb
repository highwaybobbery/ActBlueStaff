class AddNullConstraints < ActiveRecord::Migration[7.0]
  # NOTE: In a live system we would need to data cleanup to fix these records!
  def up
    change_column_null :users, :email, false
    change_column_null :candidates, :name, false
    change_column_null :votes, :user_id, false
    change_column_null :votes, :candidate_id, false
  end

  def down
    # we don't want to remove these constraints on rollback!
  end
end
