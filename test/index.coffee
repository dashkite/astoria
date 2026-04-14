import assert from "@dashkite/assert"
import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import { PostController } from "../src"

do ->

  print await test "Dashkite Astoria", [

    test "PostController", [
      test "resolve post", ->
        controller = await PostController.resolve post: bindings: key: "test-post"
        events = controller.listen()
        { value: event } = await events.next()
        assert.equal event.value.post.key, "test-post"
    ]

  ]

  process.exit if success then 0 else 1
