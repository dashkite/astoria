import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import ProfileValue from "#values/profile"
import BlogValue from "#values/blog"
import PostsValue from "#values/posts"
import PostValue from "#values/post"

export default ->

  test "Value", [

    test "Profile", do ({ data, value } = {}) ->
      data = name: "John Doe"
      [
        test "from", ->
          value = ProfileValue.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "John Doe", value.displayName
          value.name = "Jane Doe"
          assert.equal "Jane Doe", value.displayName
      ]

    test "Blog", do ({ data, value } = {}) ->
      data = title: "My Blog"
      [
        test "from", ->
          value = BlogValue.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "My Blog", value.title
          value.title = "Updated Title"
          assert.equal "Updated Title", value.title
      ]

    test "Posts", do ({ data, value } = {}) ->
      data = items: [ "a", "b", "c" ]
      [
        test "from", ->
          value = PostsValue.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.deepEqual data.items, value.items
      ]

    test "Post", do ({ data, value } = {}) ->
      data = 
        content: """
          ---
          title: Hello, World
          author: John Doe
          ---

          Content
        """
      [
        test "from", ->
          value = PostValue.from data
          assert.deepEqual data, value.data

        test "toJSON", ->
          assert.deepEqual data,
            JSON.parse JSON.stringify value

        test "properties", ->
          assert.equal "Hello, World", value.title
          assert.equal "John Doe", value.author
          value.content = """
            ---
            title: New Title
            author: Jane Doe
            ---

            New Content
          """
          assert.equal "New Title", value.title
          assert.equal "Jane Doe", value.author
      ]

  ]
