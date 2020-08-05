<template>
  <article class="post">
    <aside ref="aside" class="meta__tags">
      <ul>
        <li v-for="tag in post.tags">
          <a class="meta__tag" :href="tag.path">#{{ tag.title }}</a>
        </li>
      </ul>
    </aside>

    <header ref="header" class="post__title">
      <h1>
        <template v-if="main">
          {{ post.title }}
        </template>
        <template v-else>
          <a :href="post.path">{{ post.title }}</a>
        </template>
      </h1>
    </header>

    <div
      class="post__content"
      v-html="post.content"
      ref="postContent"
    />

    <footer ref="footer" class="post__meta">
      <div class="meta__avatar">
        <e-external :href="author.website">
          <g-image
            height="46"
            :src="author.avatar"
            :alt="author.avatarAlt"
            fit="contain"
            width="46"
          />
        </e-external>
      </div>

      <span class="meta__author">
        <e-external
          :href="post.author.website"
          :text="post.author.name"
        />
      </span>

      <div class="meta__date">
        <e-from-now :time="post.date" />
      </div>
    </footer>

    <aside v-if="!main && readMore" class="post__read">
      <a :href="post.path">Read More ({{ post.timeToRead }} min. read) ≫</a>
    </aside>
  </article>
</template>

<script>
  function trimPostContent(ctx, el) {
    if (!ctx.trim) return;

    while (el.childNodes.length > ctx.limit) {
      el.removeChild(
        el.lastChild
      )
    }
  }

  export default {
    name: "PostPartial",
    props: {
      main: Boolean,
      trim: Boolean,
      post: Object,
      readMore: {
        type: Boolean,
        default: true
      },
      limit: {
        type: Number,
        default: 3
      }
    },
    computed: {
      author() {
        return {
          website: this.post.author.website,
          avatarAlt: `Avatar for: ${this.post.author.name}`,
          avatar: require(
            `!!assets-loader!@/assets/${
              this.post.author.avatar_small
            }`
          ),
        }
      }
    },
    mounted() {
      trimPostContent(this,
        this.$refs.postContent
      );
    }
  }
</script>

<style lang=scss scoped>
  @import "../scss/scss_vars";

  .post {
    font-size: 1.06rem;
    color: var(--grey-800);
    max-width: var(--layout-width);
    line-height: 1.9rem;
    width: 100%;
    float: left;
  }

  /**
   * Because the content is dynamic, and it
   * comes from another part of the system vue.js,
   * and gridsome know very little about it before
   * it gets parsed, so we need to make sure it's
   * deep to cover all our bases!
   */
  .post__content::v-deep {
    h2,
    h3,
    h4,
    h5,
    h6 {
      color: var(--blue-600);
      font-family: var(--system-font-family);
      letter-spacing: -0.06rem;
    }

    p {
      margin: 2rem 0;
      padding: 0;
    }

    blockquote {
      display: block;
      font-style: italic;
      border-left: 4px solid var(--blue-600);
      box-sizing: border-box;
      padding: 0 0.5rem;

      p {
        margin: 0.5rem 0;
      }
    }

    :not(pre) code {
      font-size: 0.9rem;
      color: var(--grey-700);
      background-color: var(--grey-200);
      border: 1px solid var(--grey-400);
      padding: 0.2rem 0.1rem;
      border-radius: 0.3rem;
    }

    pre[class*="language-"] {
      color: #abb2bf;
      margin: 2rem 0;
      word-break: normal;
      line-height: 1.3rem;
      letter-spacing: normal;
      background: var(--grey-900);
      font-family: var(--dank-mono-font-family);
      box-sizing: border-box;
      word-spacing: normal;
      padding: 1rem 1rem;
      position: relative;
      word-wrap: normal;
      text-align: left;
      white-space: pre;
      font-size: 1rem;
      overflow: auto;
      hyphens: none;
      width: 100%;
      tab-size: 8;

      > code {
        background: none;
        font-size: inherit;
        border: none;
      }

      ::selection, &::selection {
        text-shadow: none;
        background: var(
          --blue-600
        );
      }

      &[data-expanded="true"] {
        width: 100vw;
        margin-left: -50vw;
        left: 50%;
      }

      .token {
        &.prolog,
        &.comment,
        &.doctype,
        &.cdata {
          color: var(
            --grey-600
          );
        }

        &.punctuation {
          color: var(
            --grey-400
          );
        }

        &.selector,
        &.tag {
          color: var(
            --orange-400
          );
        }

        &.boolean,
        &.property,
        &.attr-name,
        &.constant,
        &.number,
        &.symbol,
        &.deleted {
          color: var(
            --yellow-600
          );
        }

        &.char,
        &.string,
        &.attr-value,
        &.builtin,
        &.inserted {
          color: var(
            --green-400
          );
        }

        &.url,
        &.operator,
        &.entity,
        .language-css &.string,
        .style &.string {
          color: var(
            --blue-400
          );
        }

        &.atrule,
        &.keyword {
          color: var(
            --purple-400
          );
        }

        &.function {
          color: var(
            --blue-400
          );
        }

        &.regex,
        &.important,
        &.variable {
          color: var(
            --purple-400
          );
        }

        &.important,
        &.bold {
          font-weight: bold;
        }

        &.italic {
          font-style: italic;
        }

        &.entity {
          cursor: help;
        }
      }
    }
  }

  .post__meta {
    float: left;
    margin-bottom: 2rem;
    grid-template-columns: repeat(auto-fill, minmax(52px, 1fr));
    max-width: 100%;
    display: grid;
    width: 100%;
  }

  .meta__avatar {
    grid-row: 1 / 4;

    a {
      width: 2.9rem;
      height: 2.9rem;
      border-radius: 50%;
      border: 2px solid var(--grey-300);
      padding: 1px;
      float: left;

      img {
        height: inherit;
        border-radius: 50%;
        width: inherit;
      }
    }
  }

  .meta__author {
    line-height: 1.2em;
    margin: 0.23rem 0 0 .5rem;
    grid-column-start: 2;
    white-space: nowrap;
    padding: 0;
  }

  .meta__tags {
    margin: 6rem 0 0;
    grid-column-start: 2;
    display: inline-block;
    list-style-type: none;
    line-height: 1em;
    padding: 0;

    ul {
      padding: 0;
      margin: 0;
    }

    li {
      font-size: 0.9rem;
      line-height: inherit;
      display: inline;

      &:hover {
        a {
          background-color: var(--blue-600);
          color: var(--blue-200);
        }
      }

      a {
        text-decoration: none;
        color: var(--purple-200);
        background-color: var(--purple-600);
        padding: 0.4rem 0.7rem;
        border-radius: 120px;
      }

      &::after {
        content: "\a";
      }
    }
  }

  .meta__date {
    margin: 0 0 0 0.5rem;
    grid-column: 2 / -1;
  }

  .post__read {
    float: left;
    margin-bottom: 1rem;
    letter-spacing: -0.04rem;
    text-align: right;
    width: 100%;

    a {
      text-decoration: none;
    }
  }

  .post__title {
    h1 {
      line-height: 4rem;
      letter-spacing: -0.06rem;
      font-family: var(--system-font-family);
      color: var(--pink-600);
      font-size: 1.7rem;
      margin: 0 0 3rem;
      font-weight: 800;

      a {
        text-decoration: none;
        color: inherit;

        &:hover {
          color: var(--purple-600);
        }
      }
    }
  }

  @media (max-width: $medium-screen) {
    .post__title {
      h1 {
        line-height: 2.2rem;
      }
    }
  }

  @media (max-width: $small-screen) {
    .post {
      line-height: 1.6rem;
    }
  }
</style>
