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

  mutation do
    @desc "Create a user"

    field :user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &DevNotex.UserResolver.create/2
    end
  end
end
