<template>
  <PageLayout :many="true">
    <div class="tags">
      <ul>
        <li class="tag__item" v-for="edge in $page.tags.edges">
          <a :href="edge.node.path">
            {{ edge.node.title }}
          </a>
        </li>
      </ul>
    </div>
    <ArchivePartial
      :posts="$page.posts"
    />
  </PageLayout>
</template>

<style lang=scss scoped>
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  .tags {
    margin: 6rem 0 0;
    float: left;

    ul {
      width: 80%;
      margin: 0 auto;
      font-size: 1rem;
      align-items: center;
      justify-content: center;
      flex-wrap: wrap;
      display: flex;
      padding: 0;
    }
  }

  .tag__item {
    line-height: 1em;
    list-style-type: none;
    letter-spacing: var(--archives-tag-letter-spacing);
    box-shadow: 1px 1px 2px var(--archives-tag-box-shadow-color);
    background-color: var(--archives-tag-background-color);
    font-size: var(--archives-tag-font-size);
    border-radius: 1024rem;
    padding: .6rem 1rem;
    margin: .4rem;

    &:hover {
      background-color: var(--archives-tag-background-hover-color);
    }

    a {
      color: var(--archives-tag-color);
      text-decoration: none;
      &:hover {
        color: var(--archives-tag-hover-color);
      }
    }
  }

  @media (max-width: $medium-screen) {
    .tags {
      ul {
        width: 100%;
      }
    }
  }
</style>

<script>
  import ArchivePartial from "../components/Archive";
  import PageLayout  from "../layouts/Page";
  export default {
    components: {
      ArchivePartial,
      PageLayout
    }
  };
</script>

<page-query lang=graphql>
  query {
    posts: allPost(sortBy: "date", order: DESC) {
      edges {
        node {
          date
          title
          path

          tags(limit: 1) {
            title
            path
          }
        }
      }
    }
  }
</page-query>
