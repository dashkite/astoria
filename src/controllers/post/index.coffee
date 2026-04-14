import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import Post from "#models/post"

class Controller extends do ( resources 
    post:
      template: "mock:/post/{key}"
  )

  @fallbacks
    post: mock

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      # extract serializable post
      context.post = context.post.data
      context

  listen: ->
    await yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "*"
      .when "value", ( event ) ->
        yield {
          event...
          value: 
            post: Post.from event.value.post
        }

export default Controller