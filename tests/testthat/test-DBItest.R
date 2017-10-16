# get connect_args
if (identical(Sys.getenv("CIRCLECI"), "true")) Sys.setenv(R_CONFIG_ACTIVE = "circleci")

tweaks <- DBItest::tweaks(
  # Though "RRedash" is possible, I chose "Redash" because this seems more natural.
  constructor_name = "Redash",

  # Redash needs to be specified its backend.
  constructor_relax_args = TRUE,

  # Redash probably cannot work well with BLOBs.
  omit_blob_tests = TRUE
)

DBItest::make_context(
  Redash(),
  connect_args = config::get("connect_args"),
  tweaks = tweaks
)
DBItest::test_getting_started()
DBItest::test_driver(
  skip = c(
    # Redash cannot determine the type of backend before connecting
    "data_type_driver"
  )
)
