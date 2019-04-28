import { DateTime } from "luxon";

/**
 * formatTime allows you to format time
 * @param string [String] the time in an ISO format
 * @see https://vuejs.org/v2/guide/filters.html
 * @return [String]
 */
export function formatTime(string, format) {
  let time = DateTime.fromISO(string);
  return time.toFormat(
    format
  );
}
