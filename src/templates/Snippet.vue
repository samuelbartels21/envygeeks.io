<template>
  <PostLayout>
    <PostPartial
      :excerpt=false
      :hideTitle=true
      :post="$page.snippet"
      :main=true
    />
  </PostLayout>
</template>

<page-query>
  query Snippet($path: String!) {
    snippet: snippet(path: $path) {
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
</page-query>

<script>
  import PostPartial from "../components/partials/Post";
  import PostLayout from "../layouts/Post";
  export default {
    components: {
      PostPartial,
      PostLayout
    },
    metaInfo() {
      return {
        title: this.$page.snippet.title,
        meta: [
          {
            content: this.$page.snippet.author.name,
            name: "author"
          }
        ]
      }
    }
  }
</script>
