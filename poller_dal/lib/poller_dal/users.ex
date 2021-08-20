defmodule PollerDal.Users do
  import Ecto.Query
  alias PollerDal.Repo
  alias PollerDal.Users.User

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # makes user admin
  def put_admin(%User{} = user, admin \\ true) do
    user
    |> User.admin_changeset(%{admin: admin})
    |> Repo.update()
  end

  # query functions below --------------------------------
  # Gets individual user from users table in database viva id
  #! signifies func will throw error is call fails
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) do
    email = String.downcase(email)

    from(
      u in User,
      where: u.email == ^email
    )
    |> Repo.one()
  end

  # authenticates user account input
  def authenticate(email, password) do
    user = get_user_by_email(email)

    # if user exits and call to verify pass is true return tuple
    cond do
      user && Argon2.verify_pass(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :bad_password}

      True ->
        {:error, :bad_email}
    end
  end
end
