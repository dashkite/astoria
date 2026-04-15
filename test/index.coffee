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

  results = await test "Dashkite Astoria", [

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

      test "Blog", ->
        blog = Models.Blog.from title: "My Blog", subdomain: "test"
        assert.equal blog.title, "My Blog"
        assert.equal blog.subdomain, "test"
    ]

    test "Controllers", [
      test "Post", [
        test "resolve and listen", ->
          key = "test-post"
          url = "mock:/post/#{key}"
          Storage.set url,
            key: key
            content: "# Test Post"

          controller = Controllers.Post.make()
          await yield from do ->
            for await event from controller.listen()
              if event.name == "value"
                assert.equal event.value.post.title, "Test Post"
                assert.equal (event.value.post instanceof Models.Post), true
                break
              yield event
            controller.resolve post: bindings: { key }
      ]

      test "Blog", [
        test "put updates storage", ->
          url = "mock:/blog"
          Storage.set url, title: "Original"
          
          controller = Controllers.Blog.make()
          await yield from do ->
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
            controller.resolve blog: {}
      ]

      test "Posts", [
        test "add empty post", ->
          url = "mock:/posts/my-blog"
          Storage.set url, content: []
          
          controller = Controllers.Posts.make()
          await yield from do ->
            for await event from controller.listen()
              if event.name == "value"
                if event.value.posts.content.length == 1
                  assert.equal (Storage.get "mock:/post/#{event.value.posts.content[0].key}").title, "Working Title"
                  break
                else
                  controller[ "add empty post" ]()
              yield event
            controller.resolve posts: bindings: key: "my-blog"
      ]
    ]

  ]

  print results
  process.exit if success results then 0 else 1
