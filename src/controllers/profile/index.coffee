import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import resources from "@dashkite/addison/mixins/resources"
import Profile from "#models/profile"

Address =
  generate: ->
    crypto.randomUUID().split("-")[0]

Lakeshore.register "mock:/profiles/{email}", {
  Lakeshore.defaults...
  put: ({ url, bindings: { email } }, value = {}) ->
    value.email ?= email
    if ( content = Storage.get url )?
      Storage.set url, value
      description: "ok", content: value
    else
      Storage.set url, value
      description: "created", content: value
}

class Controller extends do ( resources 
    profile:
      template: "mock:/profiles/{email}"
  )

  resolve: ( specifier ) ->
    await @model.resolve 
      profile: bindings: email: specifier.profile.bindings.email
    await @start?()
    @

  create: ( data ) ->
    @resources.profile.put data

  put: ( mutator ) ->
    @model.put ( context ) ->
      context = mutator context
      context.profile = context.profile.data
      context

  listen: ->
    yield from EventReactor
      .make @model.listen()
      .bind @
      .forward "!model.value, !model.created"
      .when "model.value", ( event ) ->
        yield {
          event...
          value: 
            profile: Profile.from event.value.profile
        }
        await return
      .when "model.created", ( event ) ->
        if event.source == "profile"
          profile = event.value
          address = Address.generate()
          profile.blog = { address }
          @put ( context ) ->
            context.profile = Profile.from profile
            context
        await return
    await return

export default Controller
