import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import { Blog } from "@dashkite/astoria/controllers"
import Value from "#values/blog"
import { wait } from "../helpers"

export default ->

  test "Blog", [

    test "Mock", []

    test "Value", do ({ data, value } = {}) ->

      data = title: "My Blog"

      [
        test "from", ->
          value = Value.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "My Blog", value.title
          value.title = "Updated Title"
          assert.equal "Updated Title", value.title
      ]

    test "Controller", []

  ]
