import DefaultLayout from "~/layouts/Default.vue"
export default function (Vue, { router, head, isClient }) {
  Vue.component("Layout", DefaultLayout)

  /**
   * Google Fonts
   * @todo Eventually this should be hosted
   *   by me to remove privacy concerns.
   */
  head.link.push({
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css?family=" +
      "Lora:300,300i,400,400i|" +
      "Montserrat:300,300i,400,400i,700,700i|" +
      "Noto+Sans:400,400i|" +
      "IBM+Plex+Mono:400"
  })
}
