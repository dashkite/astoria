import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import Providers from "@dashkite/belmont/providers"
import Lakeshore from "@dashkite/lakeshore"

Providers.add "mock", Lakeshore

tests = ( name ) ->

  ( await import( "./groups/#{ name }" )).default()

do ->

  print await test "Astoria", [
    await tests "post"
    await tests "posts"
    await tests "blog"
    await tests "profile"
  ]

  process.exit if success then 0 else 1
