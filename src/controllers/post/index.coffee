import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import mock from "./mock"
import Post from "#models/post"

Lakeshore.register "mock:/post/{address}", {
  Lakeshore.defaults...
  delete: ({ url, bindings: { address } }) ->
    Storage.remove url
    # We assume "my-blog" for now as it's the only one in the mock
    # Wait, we need to know the blog address.
    # For now, let's assume we can find which blog this post belongs to
    # or just skip this part until we have more blogs.
    # Actually, let's just use "my-blog" for the mock list.
    if ( posts = Storage.get "mock:/posts/my-blog" )?
      posts.content = posts.content.filter ( p ) -> p.address != address
      Storage.set "mock:/posts/my-blog", posts
    { description: "ok" }
}

class Controller extends do ( resources 
    post:
      template: "mock:/post/{address}"
  )

  @fallbacks
    post: mock

  resolve: ( specifier ) ->
    await @model.resolve 
      post: bindings: address: specifier.post.bindings.address
    await @start?()
    @

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      # extract serializable post
      context.post = context.post.data
      context

  remove: -> @model.remove()

  listen: ->
    yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "*"
      .when "value", ( event ) ->
        yield {
          event...
          value: 
            post: Post.from event.value.post
        }
        await return
    await return

export default Controller
