import Lakeshore from "@dashkite/lakeshore"
import { Address } from "../helpers"
import fallback from "#fallbacks/posts"
import * as Post from "#mocks/post"

export create = ( data = {}) ->
  data = Object.assign {}, fallback, data
  address = data.address = Address.generate()
  data.items ?= []
  Lakeshore.defaults.put { url: "mock://posts/#{ address }" }, data
  address

Lakeshore.register "mock://posts/{address}", {
  Lakeshore.defaults...
  post: ( { url, bindings }, data ) ->
    address = Post.create data
    
    # Update the collection
    { content } = Lakeshore.defaults.get { url }
    content.items.push address
    Lakeshore.defaults.put { url }, content
    
    description: "created"
    content: { address, data... }
    locator:
      template: "mock://post/{address}"
      bindings: { address }
}
