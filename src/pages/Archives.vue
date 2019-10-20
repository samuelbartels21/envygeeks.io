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

<style lang=scss>
  @import "../components/scss/colors.scss";
  @import "../components/scss/vars.scss";

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

    .tag {
      &__item {
        color: #fff;
        padding: .4rem 1rem;
        list-style-type: none;
        box-shadow: 1px 1px 2px $grey2;
        background-color: $blue;
        border-radius: 1000px;
        line-height: 1.6rem;
        margin: .4rem;

        &:hover {
          background-color: $teal;
        }

        a {
          font-style: italic;
          font-family: $secondary-font;
          text-decoration: none;
          color: #fff;
        }
      }
    }
  }

  @media (max-width: 800px) {
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

<page-query>
  query {
    tags: allTag(sortBy: "slug", order: ASC) {
      edges {
        node {
          title
          path
        }
      }
    }

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
