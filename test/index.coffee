import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import Providers from "@dashkite/belmont/providers"
import Lakeshore from "@dashkite/lakeshore"

Providers.add "mock", Lakeshore

tests = ( name ) ->
  ( await import( "./groups/#{ name }" )).default()

do ->

  print await test "Astoria", [
    await tests "value"
    await tests "mock"
    await tests "controller"
  ]

  process.exit if success then 0 else 1
