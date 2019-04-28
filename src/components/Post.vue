<template>
  <article class=post>
    <header ref=header v-if=main class=post__title>
      <h1>
        {{ post.title }}
      </h1>
    </header>
    <header ref=header v-else class=post__title>
      <h1>
        <a :href="post.path">
          {{ post.title }}
        </a>
      </h1>
    </header>

    <div
      ref=content
      v-html="post.content"
      class=post__content
    />

    <footer ref=footer class=post__meta>
      <div class="meta__avatar meta--left">
        <ExternalLink :url="post.author.website">
          <img
            heigh=48
            :src="post.author.avatar"
            width=48
          />
        </ExternalLink>
      </div>

      <div class=meta--left>
        <div>
          <p class="meta__author meta--left">
            <ExternalLink :url="post.author.website">
              {{ post.author.name }}
            </ExternalLink>
          </p>
          <ul class="meta__tags meta--right">
            <li v-for="tag in post.tags">
              <a :href="tag.path">
                {{ tag.slug }}
              </a>
            </li>
          </ul>
        </div>

        <div class=meta__date>
          <time :datetime="post.date">
            {{ post.date | relativeTime }}
          </time>
        </div>
      </div>
    </footer>

    <aside v-if="!main" class=post__read>
      <a :href="post.path">
        Read More ({{ post.timeToRead }} min. read) ≫
      </a>
    </aside>
  </article>
</template>

<script>
  import ExternalLink from "~/components/ExternalLink.vue";
  import { expandAndContractSetup } from "~/components/ExpandAndContract.vue";

  function shorten(t) {
    let el = t.$refs.content;
    while (el.childNodes.length > 3) {
      el.removeChild(el.lastChild);
    }
  }

  export default {
    name: "Post",
    components: {
      ExternalLink
    },

    props: {
      /**
       * @param main
       * whether or not this is main
       * @val [true, false]
       */
      main: {
        required: true,
        type: Boolean
      },
      /**
       * @param trim
       * trim the post down
       * @val [true, false]
       */
      trim: {
        required: true,
        type: Boolean
      },
      /**
       * @val graphql
       * the post graphql object
       * @param post
       */
      post: {
        required: true,
        type: Object
      }
    },

    mounted() {
      if (this.trim) shorten(this);
      let selector = "pre[class*='language-']";
      let el = this.$refs.content;
      expandAndContractSetup(
        this, el, selector
      );
    }
  };
</script>

<style lang=scss>
  @import "~/assets/colors.scss";
  @import "~/assets/vars.scss";

  .post {
    color: $grey8;
    font-size: 1.125rem;
    width: $layout-width;
    line-height: 2.5rem;
    float: left;

    h2, h3, h4, h5, h6 {
      color: $blue;
    }

    p {
      margin: 2rem 0;
      padding: 0;
    }

    &__meta {
      float: left;
      width: 100%;

      .meta {
        &--right { float: right; }
        &--left  {
          float: left;
        }

        &__avatar {
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

        &__avatar + div {
          margin-left: 1rem;
        }

        &__author {
          padding: 0;
          color: $blue;
          line-height: 1.2em;
          font-weight: bold;
          margin: 0;

          a {
            text-decoration: none;
          }

          &::before { content: " by "; }
          &::after  { content: " on "; }

          &::after,
          &::before {
            font-weight: normal;
            color: darken($grey, 24);
          }
        }

        &__tags {
          margin: 0 0 0 .5rem;
          display: inline-block;
          list-style-type: none;
          line-height: 1.2em;
          padding: 0;

          &::after {
            content: "\a";
          }

          li {
            line-height: inherit;
            display: inline;

            a {
              color: inherit;
            }

            &::after {
              content: ", ";
            }

            &:last-child {
              &::after {
                content: "";
              }
            }
          }
        }
      }
    }

    &__read {
      float: left;
      text-align: right;
      width: 100%;
    }

    /**
     * Title
     */
    &__title {
      h1 {
        color: $orange;
        line-height: 4rem;
        font-style: italic;
        text-align: center;
        font-size: 3rem;
        margin: 3rem 0;

        a {
          text-decoration: none;
          color: inherit;

          &:hover {
            color: $blue;
          }
        }
      }
    }

    /**
     * Code
     * JavaScript
     * Ruby
     * Go
     */
    :not(pre) code[class*=language-] {
      font-size: 1.4rem;
      line-height: 1.4rem;
      background-color: $grey1;
      border: 1px solid $grey3;
      border-radius: .3rem;
      padding: .2rem;
    }

    pre[class*="language-"] {
      color: #abb2bf;
      background: none;
      word-break: normal;
      line-height: 1.3rem;
      background: #282c34;
      font-family: "IBM Plex Mono", monospace;
      box-sizing: border-box;
      word-spacing: normal;
      padding: 1rem 1rem;
      position: relative;
      word-wrap: normal;
      text-align: left;
      white-space: pre;
      overflow: auto;
      hyphens: none;
      width: 100%;
      tab-size: 8;

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

    .expandable-wrapper {
      .button {
        float: right;
        position: relative;
        z-index: 100;
        top: 2.5rem;
        right: 1rem;
      }

      &[data-expanded=true] {
        pre[class*="language-"] {
          width: 100vw;
          margin-left: -50vw;
          left: 50%;
        }
      }
    }

    /**
     * Quotes
     */
    blockquote {
      font-style: italic;
      border-left: 4px solid $grey3;
      padding: 0 0.5rem;

      p {
        margin: 0.5rem 0;
      }
    }
  }
</style>
