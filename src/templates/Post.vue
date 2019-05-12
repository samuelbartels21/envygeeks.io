<template>
  <PostLayout>
    <PostPartial
      :excerpt="false"
      :post="$page.post"
      :main="true"
    />
  </PostLayout>
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
        title
        path
      }
    }
  }
</page-query>

<script>
  import PostPartial from "~/components/Post";
  import PostLayout from "~/layouts/Post";
  export default {
    components: {
      PostPartial,
      PostLayout
    },
    metaInfo() {
      return {
        title: this.$page.post.title,
        meta: [
          {
            content: this.$page.post.author.name,
            name: "author"
          }
        ]
      }
    }
  }
</script>
