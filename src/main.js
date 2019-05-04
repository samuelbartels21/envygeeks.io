import toExcerpt from "./filters/toExcerpt.js";
import relativeTime from "./filters/relativeTime.js";
import formatTime from "./filters/formatTime.js";
import A_Ext from "./components/global/A-Ext.vue";
import A_GH from "./components/global/A-GH.vue";
import { headers } from "../gridsome.config.js";
import Base from "~/layouts/Base.vue";

export default function (Vue, { router, head, isClient }) {

  /**
   * {{ var | filter }}
   * Tag Filters
   */
  Vue.filter("formatTime", formatTime);     // {{ var | formatTime}}
  Vue.filter("relativeTime", relativeTime); // {{ var | relativeTime }}
  Vue.filter("toExcerpt", toExcerpt);       // {{ var | toExcerpt }}

  /**
   * Components
   */
  Vue.component("a-ext", A_Ext)
  Vue.component("Layout", Layout)
  Vue.component("a-gh", A_GH)

  /**
   * Config => Meta
   * GraphQL
   */
  Object.keys(headers).forEach(type => {
    headers[type].forEach(header => {
      head[type].push(
        header
      )
    })
  })
}
