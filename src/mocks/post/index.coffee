import Lakeshore from "@dashkite/lakeshore"
import { Address } from "../helpers"
import fallback from "#fallbacks/post"

export create = ( data = {}) ->
  data = Object.assign {}, fallback, data
  address = data.address = Address.generate()
  Lakeshore.defaults.put { url: "mock://post/#{ address }" }, data
  address
