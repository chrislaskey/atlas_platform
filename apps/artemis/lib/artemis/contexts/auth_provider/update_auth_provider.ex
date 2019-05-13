defmodule Artemis.UpdateAuthProvider do
  use Artemis.Context

  alias Artemis.AuthProvider
  alias Artemis.Repo

  def call!(id, params, user) do
    case call(id, params, user) do
      {:error, _} -> raise(Artemis.Context.Error, "Error updating auth provider")
      {:ok, result} -> result
    end
  end

  def call(id, params, user) do
    with_transaction(fn () ->
      id
      |> get_record
      |> update_record(params)
      |> Event.broadcast("auth-provider:updated", user)
    end)
  end

  def get_record(record) when is_map(record), do: record
  def get_record(id), do: Repo.get(AuthProvider, id)

  defp update_record(nil, _params), do: {:error, "Record not found"}
  defp update_record(record, params) do
    record
    |> AuthProvider.changeset(params)
    |> Repo.update
  end
end
