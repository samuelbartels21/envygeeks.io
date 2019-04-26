<template>
  <ExternalLink :url="`https://github.com/${user || $static.meta.githubUser}/${repo}`">
    <slot/>
  </ExternalLink>
</template>

<script>
  import ExternalLink from "~/components/ExternalLink.vue";
  export default {
    name: "GithubLink",
    components: {
      ExternalLink
    },

    props: {
      /**
       * @param repo
       * the repository to link
       * @val string
       */
      repo: {
        required: true,
        type: String
      },
      /**
       * @param user
       * the user for the repo
       * @val string
       */
      user: {
        required: true,
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
