import { metaclass } from "@dashkite/joy/metaclass"

class Posts extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? { items: [] }

  toJSON: -> @data

  @getters
    data: -> @_
    items: -> @_.items

export default Posts
