<template>
  <Layout>
    <div class="tags">
      <ul>
        <li class="tag__item" v-for="edge in $page.tags.edges">
          <a :href="edge.node.path">
            {{ edge.node.slug }}
          </a>
        </li>
      </ul>
    </div>
    <div class="archives">
      <div class="archive__year" v-for="edges, year in group($page.posts.edges)">
        <h2>{{ year }}</h2>

        <article v-for="edge in edges">
          <header class="left">
            <h3>
              <a :href="edge.node.path">
                {{ edge.node.title }}
              </a>
            </h3>
          </header>
          <footer class="right">
            <time :datetime="edge.node.date">
              {{ edge.node.date | relativeTime }}
            </time>
          </footer>
        </article>
      </div>
    </div>
  </Layout>
</template>

<script>
  import Layout from "~/layouts/Archive"
  import { DateTime } from "luxon"

  /**
   * group the posts by year
   * @param posts [Object] the posts object
   * @return [Object<Array>]
   */
  function groupPosts(posts) {
    let grouped = {}

    posts.forEach(post => {
      let date = DateTime.fromISO(post.node.date);
      let y = date.year;

      if (!grouped[y]) {
        grouped[y] = [
          //
        ]
      }

      grouped[y].push(post)
    })

    return grouped;
  }

  export default {
    methods: {
      group: groupPosts
    },

    components: {
      Layout
    }
  }
</script>

<style lang=scss>
  @import "~/assets/colors.scss";
  @import "~/assets/vars.scss";

  .archives {
    float: left;

    .archive {
      &__year {
        h2 {
          margin: 3rem 0;
          float: left;
        }

        article {
          width: 100%;
          border-bottom: 1px dashed $grey2;
          padding: 1rem 0;
          float: left;

          header {
            h3 {
              padding: 0;
              font-size: inherit;
              line-height: inherit;
              font-style: italic;
              margin: 0;

              a {
                text-decoration: none;
              }
            }
          }
        }
      }
    }
  }

  .left  { float: left; }
  .right {
    float: right;
  }

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
        }
      }
    }
  }
</page-query>
