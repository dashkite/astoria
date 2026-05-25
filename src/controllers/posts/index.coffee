import Atomic from "@dashkite/addison/atomic"
import Value from "#values/posts"
import Controller from "#controllers/base"
import fallback from "#fallbacks/posts"
import "#mocks/posts"

class Posts extends Controller

  @make: ->
    Object.assign ( new @ ),
      model: Atomic.make
        template: "mock:/posts/{address}"
        type: Value
        fallback: fallback

  add: ( data = {} ) ->
    @execute ->
      @model.post ( posts ) ->
        posts.data.push data
        posts

export default Posts
