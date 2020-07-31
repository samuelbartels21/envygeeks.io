import e_from_now from "./components/tags/e-from-now"
import e_external from "./components/tags/e-external"
import relativeTime from "./components/filters/relative_time.js"
import formatTime from "./components/filters/format_time.js"
import e_github from "./components/tags/e-github"
import { headers } from "../gridsome.config.js"
import BaseLayout from "./layouts/Base.vue"

export default function (Vue, { router, head, isClient }) {
  Vue.filter("formatTime", formatTime) // {{ var | formatTime }}
  Vue.filter("relativeTime", relativeTime) // {{ var | relativeTime }}
  Vue.component("BaseLayout", BaseLayout)
  Vue.component("e-external", e_external)
  Vue.component("e-github", e_github)

  /**
   * gridsome.config.js: headers
   * Edit headers inside of that file
   * they'll be mapped out here
   */
  Object.keys(headers).forEach(type => {
    headers[type].forEach(header => {
      head[type].push(
        header
      );
    });
  });
}
