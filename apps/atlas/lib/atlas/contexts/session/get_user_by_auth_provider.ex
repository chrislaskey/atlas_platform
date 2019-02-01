defmodule Atlas.GetUserByAuthProvider do
  alias Atlas.CreateUser
  alias Atlas.Repo
  alias Atlas.UpdateUser
  alias Atlas.User

  def call(%{"id" => provider} = _params) do
    case provider do
      "local" -> get_from_config()
      _ -> {:error, "Error provider not supported"}
    end
  end

  defp get_from_config do
    case Application.get_env(:atlas, :root_user) do
      nil -> {:error, "Error fetching data from provider"}
      user_data -> create_or_update_user(user_data.email, user_data)
    end
  end

  defp create_or_update_user(key, data) do
    case Repo.get_by(User, email: key) do
      nil -> CreateUser.call(data)
      user -> UpdateUser.call(user.id, data)
    end
  end
end
