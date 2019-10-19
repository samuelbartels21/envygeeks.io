<template>
  <a-ext v-if="this.name" :href="href" :text="name"/>
  <a-ext v-else :href="href"><slot/></a-ext>
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
      },
      name: {
        required: false,
        type: String
      }
    },
    computed: {
      href() {
        console.log(this.name);
        return `https://github.com/${this.ghUser}/${
          this.repo
        }`
      },
      ghUser() {
        return this.user ||
          this.$static.meta
            .githubUser
      }
    }
  }
</script>

<static-query>
  query {
    meta: metadata {
      githubUser
    }
  }
</static-query>
