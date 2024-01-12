class AddCandidateConstraint < ActiveRecord::Migration[7.0]
  def change
    add_index(:candidates, :name, unique: true)
  end
end
