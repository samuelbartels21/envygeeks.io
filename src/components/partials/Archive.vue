<template>
  <div class="archives">
    <div class="archive__year" v-for="posts in Array.from(groupedPosts)">
      <h2>{{ posts[0] }}</h2>

      <article class="post" v-for="edge in posts[1]">
        <header class="left">
          <h3>
            <a :href="edge.node.path">
              {{ edge.node.title }}
            </a>
          </h3>
        </header>
        <footer class="meta right">
          <e-format-time
            :time="edge.node.date"
            className="meta__time"
            format="MM/DD"
          />
        </footer>
      </article>
    </div>
  </div>
</template>

<script>

  /**
   * group the posts by year
   * @param posts [Object] the posts object
   * @param order [String] the order
   * @return Map<any, Array>
   */
  function group(posts, order) {
    let g = {}

    posts.forEach(post => {
      let d = new Date(post.node.date)
      let y = d.getFullYear()
      if (!g[y]) {
        g[y] = [
          //
        ]
      }

      g[y].push(
        post
      )
    })

    let o = new Map()
    let o_k = Object.keys(g).sort()
    if (order === "desc") o_k = o_k.reverse()
    o_k.forEach(k => {
      o.set(k, g[k])
    })

    return o
  }

  export default {
    name: "ArchivePartial",
    props: {
      posts: {
        required: false,
        type: Object
      },
      order: {
        default: 'asc',
        required: false,
        type: String,
      }
    },
    computed: {
      groupedPosts() {
        return group(
          this.posts.edges,
          this.order
        )
      }
    }
  }
</script>

<style lang="scss" scoped>
  .archives {
    float: left;
    width: 100%;

    .archive__year {
      h2 {
        width: 100%;
        margin: 3rem 0;
        float: left;
      }
    }

    .post {
      width: 100%;
      border-bottom: 1px dashed var(--grey-200);
      padding: 1rem 0;
      float: left;

      &:last-child {
        border-bottom: none;
      }

      header {
        h3 {
          padding: 0;
          font-size: inherit;
          line-height: inherit;
          letter-spacing: -0.03rem;
          font-weight: inherit;
          border-top: none;
          margin: 0;

          a {
            text-decoration: none;
            color: var(
              --purple-800
            );
          }
        }
      }

      .meta__time {
        color: var(
          --pink-800
        );
      }
    }
  }

  .left  { float: left; }
  .right {
    float: right;
  }
</style>
