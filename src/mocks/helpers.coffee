import { pipe } from "@dashkite/joy/function"

Address =
  generate: pipe [
    -> crypto.randomUUID()
    ( uuid ) -> uuid.replace /-/g, ""
    ( hex ) -> "0x" + hex
    ( hex ) -> BigInt hex
    ( bigint ) -> bigint.toString 36
  ]

export { Address }
