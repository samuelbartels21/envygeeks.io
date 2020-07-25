<template>
  <PostLayout :many="true">
    <PostPartial
      :trim="true"
      :key="edge.node.id"
      v-for="edge in $page.posts.edges"
      :post="edge.node"
      :main="false"
    />
  </PostLayout>
</template>

<script>
  import PostPartial from "../components/Post"
  import PostLayout from "../layouts/Post"
  export default {
    components: {
      PostPartial,
      PostLayout
    }
  }
</script>

<page-query>
  query {
    posts: allPost(perPage: 3) {
      edges {
        node {
          title
          timeToRead
          content
          date
          path

          author {
            avatar
            avatar_small
            website
            name
          }

          tags {
            title
            path
          }
        }
      }
    }
  }
</page-query>

<style lang="scss" scoped>
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  .posts {
    .post {
      border-bottom: 1px dashed var(--grey-400);
    }
  }
</style>
