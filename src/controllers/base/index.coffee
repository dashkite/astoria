import { metaclass } from "@dashkite/joy/metaclass"
import { pipe } from "@dashkite/joy/function"
import Channel from "@dashkite/reactive/channel"
import EventReactor from "@dashkite/reactive/event-reactor"
import iterable from "@dashkite/addison/mixins/iterable"

class Controller extends do pipe [ metaclass, iterable ]

  @make: ( properties ) ->
    instance = Object.assign ( new @ ),
      internal: Channel.make()
      outgoing: Channel.make()
      properties
    instance.outgoing.source instance._logic()
    instance

  @resolve: ( specifier ) ->
    ( @make() ).resolve specifier

  @getters
    value: -> @model.value

  resolve: ( specifier ) ->
    @_resolution ?= do =>
      { promise, resolve, reject } = Promise.withResolvers()
      @_send "resolve", { specifier, resolve, reject }
      promise

  execute: ( action ) ->
    { promise, resolve, reject } = Promise.withResolvers()
    @_send "request", { action, resolve, reject }
    promise

  _send: ( name, data ) ->
    @internal.send { name, scope: "internal", data... }

  _logic: ->

    EventReactor

      .make Channel.merge [ @internal, @model ]
      .bind @

      .forward "!internal.*"

      .when "internal.resolve", ( event ) ->
        try
          await @_resolve event.specifier
          event.resolve @
        catch error
          event.reject error

      .when "internal.request", ( event ) ->
        try
          event.resolve await event.action.call @
        catch error
          event.reject error

  _resolve: ( specifier ) ->
    await @model.resolve specifier

export default Controller
