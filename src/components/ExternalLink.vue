<template>
  <a v-if="this.text" :href="link" :rel="rel" target="_blank">{{ text }}</a>
  <a v-else :href="link" :rel="rel" target="_blank"><slot/></a>
</template>

<script>
  export default {
    name: "a-ext",
    props: {
      href: {
        required: true,
        type: String
      },
      text: {
        required: false,
        type: String
      }
    },
    computed: {
      link() {
        let regex = RegExp('^https?://')
        if (regex.test(this.href)) {
          return this.href
        }

        return `https://${this.href}`
      },
      rel() {
        return "noopener noreferrer nofollow"
      }
    }
  }
</script>
