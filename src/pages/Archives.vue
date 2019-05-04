<template>
  <Page :many="true">
    <div class="tags">
      <ul>
        <li class="tag__item" v-for="edge in $page.tags.edges">
          <a :href="edge.node.path">
            {{ edge.node.slug }}
          </a>
        </li>
      </ul>
    </div>
    <Archive
      :posts="$page.posts"
    />
  </Page>
</template>

<style lang=scss>
  @import "~/assets/colors.scss";
  @import "~/assets/vars.scss";

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
</style>

<script>
  import Archive from "~/components/Archive";
  import Page  from "~/layouts/Page";
  export default {
    components: {
      Archive,
      Page
    }
  };
</script>

<page-query>
  query {
    tags: allTag(sortBy: "slug", order: ASC) {
      edges {
        node {
          slug
          path
        }
      }
    }

    posts: allPost {
      edges {
        node {
          date
          title
          path

          tags(limit: 1) {
            slug
            path
          }
        }
      }
    }
  }
</page-query>
