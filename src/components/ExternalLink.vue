<template>
  <a v-if="this.text" :href="href" :rel="rel" target="_blank">{{ text }}</a>
  <a v-else :href="href" :rel="rel" target="_blank"><slot/></a>
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
      rel() {
        return "noopener noreferrer nofollow"
      }
    }
  }
</script>
