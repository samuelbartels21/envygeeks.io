<template>
  <Layout :many="true">
    <Post
      :trim="true"
      :key="edge.node.id"
      v-for="edge in $page.posts.edges"
      :post="edge.node"
      :main="false"
    />
  </Layout>
</template>

<script>
  import Post from "~/components/Post.vue"
  import Layout from "~/layouts/Post.vue"
  export default {
    components: {
      Layout,
      Post
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
            website
            name
          }

          tags {
            slug
            path
          }
        }
      }
    }
  }
</page-query>

<style lang="scss">
  @import "~/assets/colors.scss";

  .posts {
    .post {
      border-bottom: 1px dashed $grey4;

      .post__title {
        h1 {
          text-align: left;
          font-size: 1.6rem;
          margin-bottom: 0;

          a {
            text-decoration: none;
            color: $pink;
          }
        }
      }
    }
  }
</style>
