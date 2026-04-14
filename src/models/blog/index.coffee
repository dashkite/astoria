import { metaclass } from "@dashkite/joy/metaclass"

class Blog extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data

  toJSON: -> @data

  @getters
    data: -> @_
    title: -> @_.title
    description: -> @_.description
    logo: -> @_.logo
    subdomain: -> @_.subdomain

export default Blog
