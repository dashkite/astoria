import Lakeshore from "@dashkite/lakeshore"
import { Address } from "../helpers"
import fallback from "#fallbacks/blog"
import * as Posts from "#mocks/posts"

export create = ( data = {} ) ->
  data = Object.assign {}, fallback, data
  address = data.address = Address.generate()
  data.posts = address: Posts.create()
  Lakeshore.defaults.put { url: "mock:/blog/#{ address }" }, data
  address
