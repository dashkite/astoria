import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"

import Belmont from "@dashkite/belmont"
import Lakeshore from "@dashkite/lakeshore"
import { wait } from "../helpers"

import "#mocks/post"
import "#mocks/posts"
import "#mocks/blog"
import "#mocks/profile"

export default ->

  test "Mock", await do ( context = {}) ->

    [
      await test "Profile", await do ({ provider, reactor, value } = {}) ->

        provider = await Belmont.resolve "mock://profiles/j@doe.com"
        reactor = provider.subscribe()

        [

          await test "put", [

            await test "create", ->

              provider.put name: "John Doe"
              
              # Wait for the creation signal
              { value } = await wait reactor, 
                ({ name }) -> name == "created"

              context.profile = value

              assert.equal "John Doe", value.name
              assert.equal "j@doe.com", value.email
              assert value.address?
              assert value.blog.address?

            await test "update", ->

              # Update name
              provider.put { context.profile..., name: "Jane Doe" }
              
              # Wait for the value signal
              { value } = await wait reactor,
                ({ name }) -> name == "value"
              
              context.profile = value

              assert.equal "Jane Doe", value.name
              assert.equal "j@doe.com", value.email
              assert value.address?
              assert value.blog.address?
          ]
      ]

      await test "Blog", await do ({ provider, reactor, value } = {}) ->

        address = context.profile.blog.address
        provider = await Belmont.resolve "mock://blog/#{ address }"
        reactor = provider.subscribe()

        [
          await test "put", [

            await test "update", ->

              { content } = Lakeshore.defaults.get url: "mock://blog/#{ address }"
              value = content

              # Update title
              provider.put { value..., title: "Updated Blog" }
              
              # Wait for the value signal
              { value } = await wait reactor,
                ({ name }) -> name == "value"
              
              context.blog = value

              assert.equal "Updated Blog", value.title
              assert.equal address, value.address
              assert value.posts?.address?
          ]
        ]

      await test "Posts", await do ({ provider, reactor, value } = {}) ->

        address = context.blog.posts.address
        provider = await Belmont.resolve "mock://posts/#{ address }"
        reactor = provider.subscribe()

        [
          await test "post", ->

            provider.post title: "New Post"
            
            # Wait for the creation signal
            { value, locator } = await wait reactor,
              ({ name }) -> name == "created"

            assert.deepEqual locator,
              template: "mock://post/{address}"
              bindings: { address: value.address }
            
            assert.equal "New Post", value.title
            assert value.address?
            context.post = value
            
            # Verify collection updated
            provider.get "mock://posts/#{ address }"

            { value: collection } = await wait reactor,
              ({ name }) -> name == "value"
            
            assert collection.items.includes context.post.address
        ]

      await test "Post", await do ({ provider, reactor, value } = {}) ->

        address = context.post.address
        provider = await Belmont.resolve "mock://post/#{ address }"
        reactor = provider.subscribe()

        [
          await test "put", [
            await test "update", ->
              { content } = Lakeshore.defaults.get
                url: "mock://post/#{ address }"
              value = content

              # Update title
              provider.put { value..., title: "Updated Post" }
              
              # Wait for the value signal
              { value } = await wait reactor, 
                ({ name }) -> name == "value"
              
              assert.equal "Updated Post", value.title
              assert.equal address, value.address
          ]
        ]
    ]
