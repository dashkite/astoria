import YAML from "js-yaml"
import * as Fn from "@dashkite/joy/function"
import * as Obj from "@dashkite/joy/object"
import * as Text from "@dashkite/joy/text"
import { marked } from "marked"

frontMatter = ({ markdown, context... }) ->
  [ yaml, markdown ] = 
    markdown
      .split /^---$/gm
      .map Text.trim
      .filter ( document ) -> document.length > 0
  if markdown?
    metadata = YAML.load yaml
  else
    metadata = {}
    markdown = yaml
  { metadata, markdown }

parseMarkdown = ({ markdown, metadata, context... }) ->
    html = marked.parse markdown
    { context..., markdown, metadata, html }

augmentMetadata = ({ markdown, metadata, context... }) ->
  # If title isn't in frontmatter, try to extract it from
  # the first H1 in markdown
  unless metadata.title?
    match = markdown.match /^#\s+(.+)$/m
    ( metadata.title = match[1]) if match?
  { markdown, metadata, context... }

parse = Fn.pipe [
  frontMatter
  augmentMetadata
  parseMarkdown
]

export default parse
export { parse }
