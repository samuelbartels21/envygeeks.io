import { headers } from "../gridsome.config.js"
import { relativeTime } from "./filters/relativeTime"
import { formatTime } from "./filters/formatTime"
import Layout from "~/layouts/Default.vue"

export default function (Vue, { router, head, isClient }) {
  Vue.filter("formatTime", formatTime)
  Vue.filter("relativeTime", relativeTime)
  Vue.component("Layout", Layout)

  Object.keys(headers).forEach(type => {
    headers[type].forEach(header => {
      head[type].push(
        header
      )
    })
  })
}
