<template>
  <time v-if="!this.className" :datetime="this.time">{{ formattedTime() }}</time>
  <time v-else :class="this.className" :datetime="this.time">
    {{ formattedTime() }}
  </time>
</template>

<script>
  import relativeTime from 'dayjs/plugin/relativeTime'
  import Day from 'dayjs'
  Day.extend(
    relativeTime
  )

  export default {
    name: "e-format-time",
    props: {
      time: {
        required: true,
        type: String
      },
      className: {
        required: false,
        type: String
      },
      format: {
        required: true,
        type: String
      },
    },
    methods: {
      formattedTime() {
        let t = new Day(this.time)
        return t.format(
          this.format
        )
      }
    }
  }
</script>
