import YAML from "js-yaml"
import * as Fn from "@dashkite/joy/function"
import * as Obj from "@dashkite/joy/object"
import * as Text from "@dashkite/joy/text"
import HTML from "@dashkite/domo"
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

parseMarkdown = ({ markdown, context... }) ->
    html = marked.parse markdown
    { context..., html }

parseHTML = ({ html, context... }) ->
  elements = HTML.parse html
  root = document.createDocumentFragment()
  root.append elements...
  { root, context... }

augmentMetadata = ({ root, metadata, context... }) ->
  elements =
    title: root.querySelector "h1:first-child"
  metadata.title = elements.title?.textContent
  { root, elements, metadata, context... }
  
insertHeader = ({ root, metadata, elements, context... }) ->
  { subtitle } = metadata
  { title } = elements
  if title?
    header = document.createElement "header"
    header.append title
    if subtitle?
      elements.subtitle = HTML.div HTML.parse marked.parse subtitle
      header.append elements.subtitle
    root.prepend header
  { root, metadata, elements, context... }

parse = Fn.pipe [
  frontMatter
  parseMarkdown
  parseHTML
  augmentMetadata
  insertHeader
]

export default parse
export { parse }