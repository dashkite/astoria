import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import { Profile } from "@dashkite/astoria/controllers"
import Value from "#values/profile"
import { wait } from "../helpers"

export default ->

  test "Profile", [

    test "Mock", []

    test "Value", do ({ data, value } = {}) ->

      data = name: "Dan"

      [
        test "from", ->
          value = Value.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "Dan", value.displayName
          value.name = "Daniel"
          assert.equal "Daniel", value.displayName
      ]

    test "Controller", []

  ]
