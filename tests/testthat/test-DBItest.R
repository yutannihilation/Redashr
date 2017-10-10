tweaks <- DBItest::tweaks(
  # Though "RRedash" is possible, I chose "Redash" because this seems more natural.
  constructor_name = "Redash",

  # Redash probably cannot work well with BLOBs.
  omit_blob_tests = TRUE
)

DBItest::make_context(Redash(), connect_args = NULL, tweaks = tweaks)
DBItest::test_getting_started()
DBItest::test_driver()
