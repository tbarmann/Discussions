defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  # a comment has one user
  # has one topic
  # a user has many topics and has many comments
  # a topic has many comments and has one user

  def change do
    create table(:comments) do
      add(:content, :string)
      add(:user_id, references(:users))
      add(:topic_id, references(:topics))

      timestamps()
    end
  end
end
