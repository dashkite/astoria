import { metaclass } from "@dashkite/joy/metaclass"

class Blog extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? {}

  toJSON: -> @data

  @getters
    data: -> @_
    posts: -> @_.posts?.address

  @properties
    title:
      get: -> @_.title
      set: ( value ) -> @_.title = value
    description:
      get: -> @_.description
      set: ( value ) -> @_.description = value
    logo:
      get: -> @_.logo
      set: ( value ) -> @_.logo = value
    subdomain:
      get: -> @_.subdomain
      set: ( value ) -> @_.subdomain = value

export default Blog
