import ExternalLink from "./components/ExternalLink.vue";
import relativeTime from "./components/filters/relative_time.js";
import formatTime from "./components/filters/format_time.js";
import { headers } from "../gridsome.config.js";
import BaseLayout from "./layouts/Base.vue";
import Github from "./components/Github.vue";

export default function (Vue, { router, head, isClient }) {
  Vue.filter("formatTime", formatTime);     // {{ var | formatTime }}
  Vue.filter("relativeTime", relativeTime); // {{ var | relativeTime }}
  Vue.component("BaseLayout", BaseLayout);  // Tag: <Base>
  Vue.component("a-ext", ExternalLink);     // Tag: <a-ext>
  Vue.component("a-gh", Github);            // Tag: <a-gh>

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
