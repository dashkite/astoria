import assert from "@dashkite/assert"
import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import Providers from "@dashkite/belmont/providers"
import Lakeshore from "@dashkite/lakeshore"
import Storage from "@dashkite/storage"

import { Controllers, Models } from "../src"


# Register mock provider
Providers.add "mock", Lakeshore

do ->

  print await test "Astoria", [

    test "Models", [

      test "Post", [

        test "extracts title from markdown", ->
          post = Models.Post.from content: "# My Title\n\nSome body"
          assert.equal post.title, "My Title"
        
        test "extracts metadata from frontmatter", ->
          post = Models.Post.from content: "---\ntitle: Custom Title\n---\n# Body"
          assert.equal post.title, "Custom Title"
        
        test "generates html", ->
          post = Models.Post.from content: "Hello *World*"
          assert.equal post.html.trim(), "<p>Hello <em>World</em></p>"
      ]

      test "Blog", [

        test "create from", ->

          blog = Models.Blog.from title: "My Blog", subdomain: "test"
          assert.equal blog.title, "My Blog"
          assert.equal blog.subdomain, "test"
        
      ]

      test "Profile", [

        test "create from", ->
          profile = Models.Profile.from email: "test@example.com", blog: address: "abc123"
          assert.equal profile.email, "test@example.com"
          assert.equal profile.blog.address, "abc123"
      ]

    ]

    test "Controllers", [

      test "Post", [

        test "resolve and listen", ->
          address = "test-post"
          url = "mock:/post/#{address}"
          Storage.set url,
            address: address
            content: "# Test Post"

          controller = Controllers.Post.make()

          await do ->
            for await event from controller.listen()
              if event.name == "value"
                assert.equal event.value.post.title, "Test Post"
                assert.equal (event.value.post instanceof Models.Post), true
                break
              yield event
            controller.resolve post: bindings: { address }
      ]

      test "Blog", [

        test "put updates storage", ->

          address = "my-blog"
          url = "mock:/blog/#{address}"
          Storage.set url, title: "Original"
          
          controller = Controllers.Blog.make()
          await do ->
            for await event from controller.listen()
              if event.name == "value"
                if event.value.blog.title == "Updated"
                  assert.equal (Storage.get url).title, "Updated"
                  break
                else
                  # Trigger update on first value
                  controller.put ( context ) ->
                    context.blog.title = "Updated"
                    context
              yield event
            controller.resolve blog: bindings: { address }
      ]

      test "Posts", [

        test "add empty post", ->

          address = "my-blog"
          url = "mock:/posts/#{address}"
          Storage.set url, content: []
          
          controller = Controllers.Posts.make()

          await do ->
            for await event from controller.listen()
              if event.name == "value"
                if event.value.posts.content.length == 1
                  # default title comes from mock post content in Lakeshore setup
                  assert.equal (Storage.get "mock:/post/#{event.value.posts.content[0].address}").title, "Working Title"
                  break
                else
                  controller[ "add empty post" ]()
              yield event

            controller.resolve posts: bindings: { address }

      ]

      test "Profile", [

        test "resolve and listen", ->
          email = "test@example.com"
          url = "mock:/profiles/#{email}"
          Storage.set url, email: email, blog: address: "abc123"

          controller = Controllers.Profile.make()

          await do ->
            for await event from controller.listen()
              if event.name == "value"
                assert.equal event.value.profile.email, email
                assert.equal event.value.profile.blog.address, "abc123"
                break
              yield event
            controller.resolve profile: bindings: { email }

        test "create", ->
          email = "new@example.com"
          url = "mock:/profiles/#{email}"
          Storage.remove url

          controller = Controllers.Profile.make()

          await do ->
            for await event from controller.listen()
              if event.name == "created"
                assert.equal event.value.email, email
                assert.equal event.value.blog.address?, true
                break
              if event.name == "not found"
                controller.create email: email
              yield event
            controller.resolve profile: bindings: { email }
      ]

    ]

  ]
