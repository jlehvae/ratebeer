class AddGithubToUser < ActiveRecord::Migration
  def change
    add_column :users, :github, :boolean
  end
end
