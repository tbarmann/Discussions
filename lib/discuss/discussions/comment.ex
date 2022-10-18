defmodule Discuss.Discussions.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content]}
  schema "comments" do
    field(:content, :string)
    belongs_to(:user, Discuss.Discussions.User)
    belongs_to(:topic, Discuss.Discussions.Topic)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
