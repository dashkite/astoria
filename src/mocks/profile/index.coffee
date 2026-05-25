import Lakeshore from "@dashkite/lakeshore"
import { Address } from "../helpers"
import * as Blog from "#mocks/blog"

Lakeshore.register "mock:/profiles/{email}", {
  Lakeshore.defaults...
  put: ( { url, bindings }, data ) ->
    unless data.address?
      data.address = Address.generate()
      data.blog = address: Blog.create title: "My New Blog"
    Lakeshore.defaults.put { url }, data
}
