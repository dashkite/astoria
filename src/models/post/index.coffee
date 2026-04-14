import { metaclass } from "@dashkite/joy/metaclass"
import { parse } from "./helpers"

class Post extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data

  toJSON: -> @data

  @getters
    data: -> @_
    key: -> @_.key
    description: -> @_.description
    image: -> @_.image
    tags: -> @_.tags
    markdown: -> @content
    parsed: -> @_parsed ?= parse { @markdown }
    dom: -> [ @parsed.root.children... ]
    metadata: -> @parsed.metadata
    title: -> @metadata.title
    subtitle: -> @metadata.subtitle

  @properties
    content: 
      get: -> @_.content
      set: ( value ) ->
        @_parsed = undefined
        @_.content = value

export default Post
  