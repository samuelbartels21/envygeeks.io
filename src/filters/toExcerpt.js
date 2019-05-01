/**
 * toExcerpt converts the given element into
 * an excerpt by keeping only the specified amount
 * of text (paragraphs) you defined.
 * @return [String]
 */
export function toExcerpt(el, limit) {
  if (!limit) limit = 3
  if (typeof el === "string") {
    return fromString(
      el, limit
    )
  }

  return fromDOM(
    el, limit
  )
}

/**
 * @return [Object]
 * fromDOM runs while on the DOM element and
 * strips everything beyond the limit to retain
 * given as limit when parsing
 * @param limit [Integer]
 * @param el [Object]
 */
function fromDOM(el, limit) {
  while (el.childNodes.length > limit) {
    el.removeChild(el.lastChild)
  }

  return el
}

/**
 * @param str [String]
 * @param limit [Integer]
 * fromString converts a string to DOM, then it
 * puts that through fromDOM(), and returns the string
 * like you originally expected back!
 * @return [String]
 */
function fromString(str, limit) {
  let frag = document.createDocumentFragment()
  let temp = document.createElement("temp")

  temp.innerHTML = str
  return fromDOM(temp, limit).
    innerHTML
}
