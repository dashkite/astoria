import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import defaultPost from "../post/mock"
# import Posts from "#models/posts"

Address =
  generate: ->
    crypto.randomUUID().split("-")[0]

Lakeshore.register "mock:/posts/{address}", {
  Lakeshore.defaults...
  get: ({ url }) ->
    # Initialize with empty list if not found
    description: "ok", content: (( Storage.get url ) ? [])
  post: ({ url }, value = {}) ->
    if ( values = Storage.get url )?
      value.address ?= Address.generate()
      # fill in defaults
      value = { defaultPost..., value... }
      values.content.push value
      Storage.set "mock:/post/#{ value.address }", value
      Storage.set url, values
      description: "created", content: value
    else
      description: "not found"
}

class Controller extends do ( resources 
    posts:
      template: "mock:/posts/{address}"
  )

  @fallbacks
    posts: mock

  resolve: ( specifier ) ->
    await @model.resolve 
      posts: bindings: address: specifier.posts.bindings.address
    await @start?()
    @

  "add empty post": ->
    @resources.posts.post()

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      # extract serializable posts
      context.posts = context.posts
      context

  listen: ->
    yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "!model.value"
    await return

export default Controller
