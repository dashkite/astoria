import Atomic from "@dashkite/addison/atomic"
import Value from "#values/posts"
import Controller from "#controllers/base"
import fallback from "#fallbacks/posts"
import "#mocks/posts"

class Posts extends Controller

  @make: ->
    super
      model: Atomic.make
        template: "mock://posts/{address}"
        type: Value
        fallback: fallback

  add: ( data = {}) ->
    @execute ->
      await @model.post ( posts ) ->
        posts.items.push data
        posts
      @model.get()

  "add empty post": -> @add()

export default Posts
