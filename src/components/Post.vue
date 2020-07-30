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
      ref="postContent"
      className="post__content"
      v-html="post.content"
    />

    <footer ref="footer" class="post__meta">
      <div class="meta__avatar">
        <a-ext :href="author.website">
          <g-image
            height="46"
            :src="author.avatar"
            :alt="author.avatarAlt"
            fit="contain"
            width="46"
          />
        </a-ext>
      </div>

      <span class="meta__author">
        <a-ext
          :href="post.author.website"
          :text="post.author.name"
        />
      </span>

      <div class="meta__date">
        <time :datetime="post.date">
          {{ post.date | relativeTime }}
        </time>
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
  @import "./scss/colors";
  @import "./scss/vars";

  .post {
    color: $grey-800;
    font-size: $post-body-font-size;
    line-height: $post-body-line-height;
    max-width: $layout-width;
    width: 100%;
    float: left;

    &::v-deep {
      h2, h3, h4, h5, h6 {
        font-family: $post-title-font-family;
        letter-spacing: $post-title-letter-spacing;
        color: $blue-600;
      }

      p {
        margin: 2rem 0;
        padding: 0;
      }

      blockquote {
        display: block;
        font-style: italic;
        border-left: 4px solid $grey3;
        box-sizing: border-box;
        padding: 0 0.5rem;

        p {
          margin: 0.5rem 0;
        }
      }

      :not(pre) code {
        font-size: 0.9rem;
        background-color: $grey1;
        border: 1px solid $grey3;
        border-radius: .3rem;
        padding: .1rem;
      }

      pre[class*="language-"] {
        color: #abb2bf;
        margin: 2rem 0;
        background: none;
        word-break: normal;
        line-height: 1.3rem;
        background: #282c34;
        font-family: $mono-font;
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

         ::selection,
        &::selection {
          text-shadow: none;
          background: #9aa2b1;
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
            color: #5C6370;
          }

          &.punctuation {
            color: #abb2bf;
          }

          &.selector,
          &.tag {
            color: #e06c75;
          }

          &.boolean,
          &.property,
          &.attr-name,
          &.constant,
          &.number,
          &.symbol,
          &.deleted {
            color: #d19a66;
          }

          &.char,
          &.string,
          &.attr-value,
          &.builtin,
          &.inserted {
            color: #98c379;
          }

          &.url,
          &.operator,
          &.entity,
          .language-css &.string,
          .style &.string {
            color: #56b6c2;
          }

          &.atrule,
          &.keyword {
            color: #c678dd;
          }

          &.function {
            color: #61afef;
          }

          &.regex,
          &.important,
          &.variable {
            color: #c678dd;
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
      border: 2px solid $grey2;
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
    color: $blue;
    line-height: 1.2em;
    margin: .23rem 0 0 .5rem;
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
          background-color: var(--blue-300);
          color: var(--blue-700);
        }
      }

      a {
        text-decoration: none;
        color: var(--purple-600);
        background-color: var(--purple-200);
        letter-spacing: -0.02rem;
        border-radius: 120px;
        padding: 3px 12px;
      }

      &::after {
        content: "\a";
      }
    }
  }

  .meta__date {
    margin: 0 0 0 .5rem;
    grid-column: 2 / -1;
  }

  .post__read {
    float: left;
    margin-bottom: 1rem;
    text-align: right;
    width: 100%;

    a {
      text-decoration: none;
    }
  }

  .post__title {
    h1 {
      color: $pink-600;
      font-family: $post-title-font-family;
      letter-spacing: $post-title-letter-spacing;
      font-weight: $post-title-font-weight;
      line-height: $post-title-line-height;
      font-size: $post-title-font-size;
      margin: 0 0 3rem;

      a {
        text-decoration: none;
        color: inherit;

        &:hover {
          color: $purple-600;
        }
      }
    }
  }

  @media (max-width: ($layout-width + 50px)) {
    .post__title {
      h1 {
        line-height: 2.2rem;
      }
    }
  }

  @media (max-width: 380px) {
    .post {
      line-height: $post-body-small-screen-line-height;
    }
  }
</style>
