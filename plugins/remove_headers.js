export default (_, head) => {
  head.link = head.link.filter(h => {
    return !h.rel || (
      h.rel && (
        h.rel !== "icon" && h.rel !== "apple-touch-icon"
      )
    )
  })
}
