<template>
  <ExternalLink :url="`https://github.com/${user || $static.meta.githubUser}/${repo}`">
    <slot/>
  </ExternalLink>
</template>

<script>
  import ExternalLink from "~/components/ExternalLink.vue"
  export default {
    name: "GithubLink",
    components: {
      ExternalLink
    },

    props: {
      repo: {
        required: true,
        type: String
      },

      user: {
        required: false,
        type: String
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
