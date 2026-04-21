import { metaclass } from "@dashkite/joy/metaclass"
import { parse } from "./helpers"

class Post extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? {}

  toJSON: -> @data

  @getters
    data: -> @_
    key: -> @_.key
    description: -> @_.description
    image: -> @_.image
    tags: -> @_.tags
    markdown: -> @content
    parsed: -> @_parsed ?= parse { @markdown }
    html: -> @parsed.html
    metadata: -> @parsed.metadata
    title: -> @metadata.title
    subtitle: -> @metadata.subtitle
    author: -> @metadata.author ? @_.author
    date: -> @metadata.date ? @_.date
    status: -> if @published then "published" else "draft"

  @properties
    content: 
      get: -> @_.content
      set: ( value ) ->
        @_parsed = undefined
        @_.content = value
    published:
      get: -> @_.published ? false
      set: ( value ) -> @_.published = value

export default Post
