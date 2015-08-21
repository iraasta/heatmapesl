use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :heatmap, Heatmap.Endpoint,
  secret_key_base: "wakk8X/WxzsQVe+ORg07He6/ZAbQ5xHtS/jQlm/fLApKG7HBJfI9OEQncMPZDumT"

# Configure your database
config :heatmap, Heatmap.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "heatmap_prod",
  size: 20 # The amount of database connections in the pool
