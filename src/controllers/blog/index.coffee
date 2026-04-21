import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import Blog from "#models/blog"

Lakeshore.register "mock:/blog/{address}", {
  Lakeshore.defaults...
  get: ({ url }) ->
    # Initialize with default data if not found
    Storage.get(url) ? mock
  put: ({ url }, value = {}) ->
    if ( current = Storage.get(url) ? mock )?
      value = { current..., value... }
      Storage.set url, value
      description: "updated", content: value
    else
      description: "not found"
}

class Controller extends do ( resources
    blog:
      template: "mock:/blog/{address}"
  )

  @fallbacks
    blog: mock

  resolve: ( specifier ) ->
    await @model.resolve 
      blog: bindings: address: specifier.blog.bindings.address
    await @start?()
    @

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      context.blog = context.blog.data
      context

  listen: ->
    yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "*"
      .when "value", ( event ) ->
        yield {
          event...
          value:
            blog: Blog.from event.value.blog
        }
        await return
    await return

export default Controller
