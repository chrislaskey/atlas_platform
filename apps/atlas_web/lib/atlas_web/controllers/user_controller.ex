defmodule AtlasWeb.UserController do
  use AtlasWeb, :controller

  alias Atlas.CreateUser
  alias Atlas.User
  alias Atlas.DeleteUser
  alias Atlas.GetUser
  alias Atlas.ListRoles
  alias Atlas.ListUsers
  alias Atlas.UpdateUser

  @preload [:user_roles]

  def index(conn, _params) do
    authorize(conn, "users:list", fn () ->
      users = ListUsers.call()

      render(conn, "index.html", users: users)
    end)
  end

  def new(conn, _params) do
    authorize(conn, "users:create", fn () ->
      user = %User{user_roles: []}
      changeset = User.changeset(user)
      roles = ListRoles.call()

      render(conn, "new.html", changeset: changeset, roles: roles, user: user)
    end)
  end

  def create(conn, %{"user" => params}) do
    authorize(conn, "users:create", fn () ->
      params = checkbox_to_params(params, "user_roles")

      case CreateUser.call(params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          user = %User{user_roles: []}
          roles = ListRoles.call()

          render(conn, "new.html", changeset: changeset, roles: roles, user: user)
      end
    end)
  end

  def show(conn, %{"id" => id}) do
    authorize(conn, "users:show", fn () ->
      user = GetUser.call!(id)

      render(conn, "show.html", user: user)
    end)
  end

  def edit(conn, %{"id" => id}) do
    authorize(conn, "users:update", fn () ->
      user = GetUser.call(id, preload: @preload)
      changeset = User.changeset(user)
      roles = ListRoles.call()

      render(conn, "edit.html", changeset: changeset, roles: roles, user: user)
    end)
  end

  def update(conn, %{"id" => id, "user" => params}) do
    authorize(conn, "users:update", fn () ->
      params = checkbox_to_params(params, "user_roles")

      case UpdateUser.call(id, params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          user = GetUser.call(id, preload: @preload)
          roles = ListRoles.call()

          render(conn, "edit.html", changeset: changeset, roles: roles, user: user)
      end
    end)
  end

  def delete(conn, %{"id" => id}) do
    authorize(conn, "users:delete", fn () ->
      {:ok, _user} = DeleteUser.call(id)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :index))
    end)
  end
end
