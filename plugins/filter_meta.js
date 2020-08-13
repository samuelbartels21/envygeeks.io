export default (_, head) => {
  head.meta = head.meta.filter(m => {
    return !m.name || (
      m.name && (
        m.name !== "generator"
      )
    )
  })
}
