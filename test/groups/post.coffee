import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import { Post } from "@dashkite/astoria/controllers"
import Value from "#values/post"
import { wait } from "../helpers"

export default ->

  test "Post", [

    test "Mock", []

    test "Value", do ({ data, value } = {}) ->

      data = 
        content: """
          ---
          title: Hello, World
          ---

          Content
        """

      [
        test "from", ->
          value = Value.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "Hello, World", value.title
          value.content = """
            ---
            title: New Title
            ---

            New Content
          """
          assert.equal "New Title", value.title
      ]

    test "Controller", []

  ]
