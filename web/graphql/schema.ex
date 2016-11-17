defmodule DevNotex.Graphql.Schema do
  use Absinthe.Schema

  query do
    field :profile, :user do
      resolve fn _, %{context: %{current_user: current_user}} ->
        {:ok, current_user}
      end
    end
  end

  object :user do
    field :id, :id
    field :email, :string
  end
end
