<template>
  <a v-if="this.text" :href="link" :rel="rel" target="_blank">{{ text }}</a>
  <a v-else :href="link" :rel="rel" target="_blank"><slot/></a>
</template>

<script>
  export default {
    name: "e-external",
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
    data() {
      return {
        rel: "noopener noreferrer nofollow"
      }
    },
    computed: {
      link() {
        let regex = RegExp('^https?://')
        if (regex.test(this.href)) {
          return this.href
        }

        return `https://${this.href}`
      }
    }
  }
</script>
