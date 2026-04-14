import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import Blog from "#models/blog"

Lakeshore.register "mock:/blog", {
  Lakeshore.defaults...
  put: ({ url }, value = {}) ->
    if ( current = Storage.get url )?
      value = { current..., value... }
      Storage.set url, value
      description: "updated", content: value
    else
      description: "not found"
}

class Controller extends do ( resources
    blog:
      template: "mock:/blog"
  )

  @fallbacks
    blog: mock

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      context.blog = context.blog.data
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
            blog: Blog.from event.value.blog
        }

export default Controller
