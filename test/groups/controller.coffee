import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import { Profile, Blog, Posts, Post } from "@dashkite/astoria/controllers"
import { wait } from "../helpers"

export default ->

  test "Controller", await do ( context = {}) ->

    [

      await test "Profile", await do ({ controller, value } = {}) ->

        controller = await Profile.connect email: "j@doe.com"

        [

          await test "update", ->

            { value } = await wait controller, ({ name }) -> name == "created"

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )
            assert.equal "Profile", value.constructor.name

            controller.update name: "John Doe"

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )

            assert.equal "Profile", value.constructor.name
            assert.equal "John Doe", value.displayName
            assert value.address?
            assert value.blog?

            context.profile = value

        ]

      await test "Blog", await do ({ controller, value } = {}) ->

        if context.profile?
          controller = await Blog.resolve address: context.profile.blog

        [

          await test "update", ->
            
            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )
            assert.equal "Blog", value.constructor.name

            controller.update title: "Awesome Blog"

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )

            assert.equal "Blog", value.constructor.name
            assert.equal "Awesome Blog", value.title
            assert value.posts?

            context.blog = value
        ]

      await test "Posts", await do ({ controller, value } = {}) ->

        if context.blog?.posts?
          controller = await Posts.resolve address: context.blog.posts

        [

          await test "add", ->

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )
            assert.equal "Posts", value.constructor.name
            
            controller.add title: "My First Post"

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )

            assert.equal "Posts", value.constructor.name
            assert.equal 1, value.items.length
            context.posts = value

          await test "add empty post", ->

            controller["add empty post"]()

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )

            assert.equal "Posts", value.constructor.name
            assert.equal 2, value.items.length
            context.posts = value
        ]

      await test "Post", await do ({ controller, value } = {}) ->

        if context.posts?.items?[ 0 ]?
          controller = await Post.resolve address: context.posts.items[ 0 ]

        [

          await test "update", ->
            
            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )
            assert.equal "Post", value.constructor.name

            controller.update content: """
              ---
              title: New Title
              author: Jane Doe
              ---

              New Content
            """

            { value } = await wait controller, ({ scope, name }) ->
              ( name == "value" ) && ( scope == "model" )

            assert.equal "Post", value.constructor.name
            assert.equal "New Title", value.title

          await test "remove", ->

            controller.remove()

            event = await wait controller, ({ scope, name }) ->
              ( name == "deleted" ) && ( scope == "resource" )

            assert event?
        ]
    ]
