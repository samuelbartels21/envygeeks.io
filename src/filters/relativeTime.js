import moment from "moment";

/**
 * relativeTime turns time into "3 years ago"
 * @param string [String] the time in an ISO format
 * @return [String]
 */
export function relativeTime(string) {
  return moment(string).fromNow(
    // It's fine
  )
}
