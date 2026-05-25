import { tee } from "@dashkite/joy/function"
import Atomic from "@dashkite/addison/atomic"
import Value from "#values/post"
import Controller from "#controllers/base"
import fallback from "#fallbacks/post"
import "#mocks/post"

class Post extends Controller

  @make: ->
    Object.assign ( new @ ),
      model: Atomic.make
        template: "mock:/post/{address}"
        type: Value
        fallback: fallback

  update: ( data ) ->
    @execute ->
      @model.put tee ( post ) ->
        Object.assign post, data

  delete: ->
    @execute -> @model.delete()

export default Post
