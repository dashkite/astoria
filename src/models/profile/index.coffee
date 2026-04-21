import { metaclass } from "@dashkite/joy/metaclass"

class Profile extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? {}

  toJSON: -> @data

  @getters
    data: -> @_
    email: -> @_.email
    blog: -> @_.blog ? {}

export default Profile
