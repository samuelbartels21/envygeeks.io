<template>
  <Layout>
    <Post
      :post="$page.post"
      :main=true
    />
  </Layout>
</template>

<page-query>
  query Post($path: String!) {
    post: post(path: $path) {
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
</page-query>

<script>
  import Post from "~/components/Post.vue";
  import Layout from "~/layouts/Post.vue";
  export default {
    components: {
      Layout,
      Post
    },
    metaInfo() {
      return {
        title: this.$page.post.title
      }
    }
  }
</script>
