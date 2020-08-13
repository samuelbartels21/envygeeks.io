import { headers } from "../gridsome.config.js"
export default (_, head) => {
  Object.keys(headers).forEach(type => {
    headers[type].forEach(header => {
      head[type].push(
        header
      )
    })
  })
}
