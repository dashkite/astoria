import { tee } from "@dashkite/joy/function"
import Atomic from "@dashkite/addison/atomic"
import Value from "#values/profile"
import Controller from "#controllers/base"
import "#mocks/profile"

class Profile extends Controller

  @make: ->
    Object.assign ( new @ ),
      model: Atomic.make
        template: "mock:/profiles/{email}"
        type: Value

  update: ( data ) ->
    @execute ->
      @model.put tee ( profile ) ->
        Object.assign profile, data

export default Profile
