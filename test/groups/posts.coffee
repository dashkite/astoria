import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import { Posts } from "@dashkite/astoria/controllers"
import Value from "#values/posts"
import { wait } from "../helpers"

export default ->

  test "Posts", [

    test "Mock", []

    test "Value", do ({ data, value } = {}) ->

      data = items: [ "a", "b", "c" ]

      [
        test "from", ->
          value = Value.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.deepEqual data.items, value.items
      ]

    test "Controller", []

  ]
