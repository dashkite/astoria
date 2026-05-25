import { metaclass } from "@dashkite/joy/metaclass"
import { parse } from "./helpers"

class Post extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? {}

  toJSON: -> @data

  @getters
    data: -> @_
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
    key:
      get: -> @_.key
      set: ( value ) -> @_.key = value
    description:
      get: -> @_.description
      set: ( value ) -> @_.description = value
    image:
      get: -> @_.image
      set: ( value ) -> @_.image = value
    tags:
      get: -> @_.tags
      set: ( value ) -> @_.tags = value
    content: 
      get: -> @_.content
      set: ( value ) ->
        @_parsed = undefined
        @_.content = value
    published:
      get: -> @_.published ? false
      set: ( value ) -> @_.published = value

export default Post
