<template>
  <div class="archives">
    <div class="archive__year" v-for="edges, year in gPosts">
      <h2>{{ year }}</h2>

      <article class="post" v-for="edge in edges">
        <header class="left">
          <h3>
            <a :href="edge.node.path">
              {{ edge.node.title }}
            </a>
          </h3>
        </header>
        <footer class="meta right">
          <ul class="meta__tags">
            <li v-for="tag in edge.node.tags">
              <a :href="tag.path">
                #{{ tag.title }}
              </a>
            </li>
          </ul>
          <time class="meta__time" :datetime="edge.node.date">
            {{ edge.node.date | formatTime("MM/dd") }}
          </time>
        </footer>
      </article>
    </div>
  </div>
</template>

<script>
  import { DateTime } from "luxon"

  /**
   * group the posts by year
   * @param posts [Object] the posts object
   * @return [Object<Array>]
   */
  function grouped(posts) {
    let grouped = {
      //
    }

    posts.forEach(post => {
      let date = DateTime.fromISO(post.node.date);
      let y = date.year;
      if (!grouped[y]) {
        grouped[y] = [
          //
        ]
      }

      grouped[y].push(
        post
      );
    });

    return grouped;
  }

  export default {
    name: "ArchivePartial",
    props: {
      posts: {
        required: false,
        type: Object
      }
    },
    computed: {
      gPosts() {
        return grouped(
          this.posts.edges
        )
      }
    }
  }
</script>

<style lang="scss">
  @import "./scss/colors";

  .archives {
    float: left;
    width: 100%;

    .archive {
      &__year {
        h2 {
          margin: 3rem 0;
          float: left;
        }
      }
    }

    .post {
      width: 100%;
      border-bottom: 1px dashed $grey2;
      padding: 1rem 0;
      float: left;

      header {
        h3 {
          padding: 0;
          font-size: inherit;
          line-height: inherit;
          font-weight: inherit;
          font-style: italic;
          margin: 0;

          a {
            text-decoration: none;
          }
        }
      }

      .meta {
        &__tags {
          margin: 0;
          float: left;
          padding: 0;

          li {
            display: inline-block;

            a {
              margin-right: .3rem;
              text-decoration: none;
              color: $grey7;

              &:hover {
                color: $pink;
              }
            }
          }
        }

        &__time {
          color: $purple;
        }
      }

    }
  }

  .left  { float: left; }
  .right {
    float: right;
  }
</style>
