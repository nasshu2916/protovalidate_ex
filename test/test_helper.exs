ExUnit.start()

test_root = Path.expand(__DIR__)

test_root
|> Path.join("support/**/*.exs")
|> Path.wildcard()
|> Enum.sort()
|> Enum.each(&Code.require_file/1)
