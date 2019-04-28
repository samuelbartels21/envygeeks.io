<template>
  <a-ext :href="`https://github.com/${ghUser}/${repo}`">
    <slot/>
  </a-ext>
</template>

<script>
  export default {
    name: "a-gh",
    props: {
      repo: {
        required: true,
        type: String
      },
      user: {
        required: false,
        type: String
      }
    },
    computed: {
      ghUser() {
        return this.user || this.$static.meta.githubUser
      }
    }
  }
</script>

<static-query>
  query {
    meta: metaData {
      githubUser
    }
  }
</static-query>
