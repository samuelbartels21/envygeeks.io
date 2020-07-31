import e_from_now from "./components/tags/e-from-now"
import e_external from "./components/tags/e-external"
import e_format_time from "./components/tags/e-format-time"
import e_github from "./components/tags/e-github"
import { headers } from "../gridsome.config.js"
import BaseLayout from "./layouts/Base.vue"

export default function (Vue, { router, head, isClient }) {
  Vue.component("BaseLayout", BaseLayout)
  Vue.component("e-from-now", e_from_now)
  Vue.component("e-format-time", e_format_time)
  Vue.component("e-external", e_external)
  Vue.component("e-github", e_github)

  /**
   * Remove unwanted headers
   * We don't need these.
   */
  head.link = head.link.filter(h => {
    return !h.rel || (
      h.rel && (
        h.rel !== "icon" && h.rel !== "apple-touch-icon"
      )
    )
  })

  /**
   * Remove unwanted metadata
   * Generators add a lot.
   */
  head.meta = head.meta.filter(m => {
    return !m.name || (
      m.name && (
        m.name !== "generator"
      )
    )
  })

  /**
   * gridsome.config.js: headers
   * Edit headers inside of that file
   * they'll be mapped out here
   */
  Object.keys(headers).forEach(type => {
    headers[type].forEach(header => {
      head[type].push(
        header
      )
    })
  })
}
