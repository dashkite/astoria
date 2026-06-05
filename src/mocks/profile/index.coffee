import Lakeshore from "@dashkite/lakeshore"
import { Address } from "../helpers"
import * as Blog from "#mocks/blog"

Lakeshore.register "mock://profiles/{email}", {
  Lakeshore.defaults...
  put: ({ url, bindings }, data ) ->
    response = Lakeshore.defaults.get { url }
    switch response.description
      when "ok"
        { address, email, blog, rest... } = response.content
        response = Lakeshore.defaults.put { url },
          { rest..., data..., bindings..., address, blog }
        response
      when "not found"
        Lakeshore.defaults.put { url }, {
          data...
          bindings...
          address: Address.generate()
          blog:
            address: Blog.create title: "Untitled"
        }
        
}
