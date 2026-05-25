import { tee } from "@dashkite/joy/function"
import Atomic from "@dashkite/addison/atomic"
import Value from "#values/blog"
import Controller from "#controllers/base"
import fallback from "#fallbacks/blog"
import "#mocks/blog"

class Blog extends Controller

  @make: ->
    Object.assign ( new @ ),
      model: Atomic.make
        template: "mock:/blog/{address}"
        type: Value
        fallback: fallback

  update: ( data ) ->
    @execute ->
      @model.put tee ( blog ) ->
        Object.assign blog, data

export default Blog
