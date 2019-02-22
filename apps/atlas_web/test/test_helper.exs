{:ok, _} = Application.ensure_all_started(:hound)
ExUnit.configure(exclude: [pending: true])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Atlas.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(AtlasLog.Repo, :manual)
