<template>
  <e-external v-if="this.name" :href="href" :text="name"/>
  <e-external v-else :href="href"><slot/></e-external>
</template>

<script>
  export default {
    name: "e-github",
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
