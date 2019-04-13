<template>
  <ext-link :url="`https://github.com/${user || $static.meta.githubUser}/${repo}`">
    <slot/>
  </ext-link>
</template>

<script>
  import extLink from "~/components/ext-link.vue";
  export default {
    name: "gh-link",
    components: {
      extLink
    },
    props: [
      "repo",
      "user"
    ]
  }
</script>

<static-query>
query {
  meta: metaData {
    githubUser
  }
}
</static-query>
