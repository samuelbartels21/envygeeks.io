<template>
  <PostLayout :page-title="title">
    <header class="page__title">
      <h1>{{ title }}</h1>
    </header>
    <ArchivePartial
      :posts="$page.tag.belongsTo"
    />
  </PostLayout>
</template>

<style lang="scss">
  @import "../components/scss/vars";

  .page__title {
    text-align: center;
    margin: 3rem 0;

    h1 {
      font-size: 3rem;
      text-align: center;
      font-style: italic;
      line-height: 4rem;
      margin: 0 0 3rem;
    }
  }
</style>

<script>
  import ArchivePartial from "../components/Archive"
  import PostLayout  from "../layouts/Post"
  export default {
    components: {
      ArchivePartial,
      PostLayout
    },
    computed: {
      title() {
        return `tag: ${this.$page.tag.title}`
      }
    },
    metaInfo() {
      return {
        title: this.title,
      }
    }
  }
</script>

<page-query>
  query tag($path: String!) {
    tag(path: $path) {
      title

      belongsTo {
        edges {
          node {
            ... on Post {
              date
              title
              path
            }
          }
        }
      }
    }
  }
</page-query>
