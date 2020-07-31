<template>
  <div class="archives">
    <div class="archive__year" v-for="edges,year in gPosts">
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

<style lang="scss" scoped>
  @import "../scss/colors";

  .archives {
    float: left;
    width: 100%;

    .archive__year {
      h2 {
        margin: 3rem 0;
        float: left;
      }
    }

    .post {
      width: 100%;
      border-bottom: 1px dashed var(--grey-400);
      padding: 1rem 0;
      float: left;

      header {
        h3 {
          padding: 0;
          font-size: inherit;
          letter-spacing: -0.02rem;
          line-height: inherit;
          font-weight: inherit;
          margin: 0;

          a {
            text-decoration: none;
          }
        }
      }

      .meta__time {
        color: var(--purple-500);
      }
    }
  }

  .left  { float: left; }
  .right {
    float: right;
  }
</style>
