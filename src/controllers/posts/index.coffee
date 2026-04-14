import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import defaultPost from "../post/mock"
# import Posts from "#models/posts"

Key =
  generate: ->
    crypto.randomUUID().split("-")[0]

Lakeshore.register "mock:/posts/{key}", {
  Lakeshore.defaults...
  post: ({ url }, value = {}) ->
    if ( values = Storage.get url )?
      value.key ?= Key.generate()
      # fill in defaults
      value = { defaultPost..., value... }
      values.content.push value
      Storage.set "mock:/post/#{ value.key }", value
      Storage.set url, values
      description: "created", content: value
    else
      description: "not found"
}

class Controller extends do ( resources 
    posts:
      template: "mock:/posts/{key}"
  )

  @fallbacks
    posts: mock

  "add empty post": ->
    @resources.posts.post()

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      # extract serializable post
      context.posts = context.posts
      context

  listen: ->
    await yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "*"

export default Controller