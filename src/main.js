import a_ext from "./components/a_ext.vue";
import relativeTime from "./filters/relative_time.js";
import formatTime from "./filters/format_time.js";
import { headers } from "../gridsome.config.js";
import BaseLayout from "~/layouts/Base.vue";
import a_gh from "./components/a_gh.vue";

export default function (Vue, { router, head, isClient }) {
  Vue.filter("formatTime", formatTime);     // {{ var | formatTime}}
  Vue.filter("relativeTime", relativeTime); // {{ var | relativeTime }}
  Vue.component("BaseLayout", BaseLayout);  // Tag: <Base>
  Vue.component("a-ext", a_ext);            // Tag: <a-ext>
  Vue.component("a-gh", a_gh);              // Tag: <a-gh>

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
