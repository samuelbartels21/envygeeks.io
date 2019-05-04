<template>
  <Post>
    <PostCard
      :post="$page.post"
      :main="true"
    />
  </Post>
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
  import PostCard from "~/components/Post.vue";
  import Post from "~/layouts/Post.vue";
  export default {
    components: {
      PostCard,
      Post
    },
    metaInfo() {
      return {
        title: this.$page.post.title
      }
    }
  }
</script>
