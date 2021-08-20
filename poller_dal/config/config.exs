import Config

config :poller_dal, PollerDal.Repo,
  database: "poller_#{Mix.env()}",
  username: "AR",
  password: "AR",
  hostname: "localhost"

# config given when gen the repo in terminal
config :poller_dal, ecto_repos: [PollerDal.Repo]
