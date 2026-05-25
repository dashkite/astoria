import { metaclass } from "@dashkite/joy/metaclass"

class Profile extends metaclass()

  @from: ( data ) ->
    Object.assign ( new @ ), _: data ? {}

  toJSON: -> @data

  @getters
    data: -> @_
    displayName: -> @name
    address: -> @_.address
    blog: -> @_.blog?.address

  @properties
    name:
      get: -> @_.name
      set: ( value ) -> @_.name = value

export default Profile
