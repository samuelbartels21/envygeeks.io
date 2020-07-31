<template>
  <time :time="this.unformattedTime">
    {{ relativeTime }}
  </time>
</template>

<script>
  import relativeTime from 'dayjs/plugin/relativeTime'
  import Day from 'dayjs'
  Day.extend(
    relativeTime
  )

  export default {
    name: "e-from-now",
    self: this,
    props: {
      time: {
        required: true,
        type: String
      },
    },
    data() {
      return {
        currentInterval: null,
        unformattedTime: this.time,
        relativeTime: null,
      }
    },
    created() {
      this.relativeTime = this.makeRelativeTime()
      this.currentInterval = setInterval(() => {
        this.relativeTime = this.makeRelativeTime(
          // Automatic
        )
      }, 6000)
    },
    beforeDestroy() {
      if (this.currentInterval) {
        clearInterval(
          this.currentInterval
        )
      }
    },
    methods: {
      makeRelativeTime() {
        let t = new Day(this.unformattedTime)
        return t.fromNow(
          // 1 Day Ago
        )
      }
    }
  }
</script>
