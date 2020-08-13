import e_from_now from "./components/tags/e-from-now"
import e_external from "./components/tags/e-external"
import e_format_time from "./components/tags/e-format-time"
import import_html_headers from "../plugins/import_html_headers"
import remove_headers from "../plugins/remove_headers"
import e_github from "./components/tags/e-github"
import filter_meta from "../plugins/filter_meta"
import base_layout from "./layouts/Base.vue"


export default function (Vue, { router, head, isClient }) {
  Vue.component(e_from_now.name , e_from_now)
  Vue.component(base_layout.name, base_layout)
  Vue.component(e_format_time.name, e_format_time)
  Vue.component(e_external.name, e_external)
  Vue.component(e_github.name, e_github)
  import_html_headers(router, head)
  remove_headers(router, head)
  filter_meta(router, head)
}
