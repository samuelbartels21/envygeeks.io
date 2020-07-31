import e_github from "./components/tags/e-github"
import e_external from "./components/tags/e-external"
import relativeTime from "./components/filters/relative_time.js"
import formatTime from "./components/filters/format_time.js"
import { headers } from "../gridsome.config.js"
import BaseLayout from "./layouts/Base.vue"

export default function (Vue, { router, head, isClient }) {
  Vue.filter("formatTime", formatTime) // {{ var | formatTime }}
  Vue.filter("relativeTime", relativeTime) // {{ var | relativeTime }}
  Vue.component("BaseLayout", BaseLayout) // Tag: <Base>
  Vue.component("a-ext", e_external) // Tag: <a-ext>
  Vue.component("a-gh", e_github) // Tag: <a-gh>

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
