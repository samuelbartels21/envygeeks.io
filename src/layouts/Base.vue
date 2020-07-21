<template>
  <div class="layout">
    <header class="header">
      <div class="title">
        <span class="title__one">
          <g-link to="/" rel="me">
            {{ $static.meta.title }}
          </g-link>
        </span>
        <span class="title__two">
          {{ $static.meta.subTitle }}
        </span>
      </div>
      <nav class="nav">
        <ul>
          <li class="nav__item" v-for="nav in $static.meta.nav" :key="nav.id">
            <g-link :to="nav.to">
              {{ nav.title }}
            </g-link>
          </li>
        </ul>
      </nav>
    </header>
    <slot />
  </div>
</template>

<style lang=scss>
  @import "../components/scss/fonts";
  @import "../components/scss/normalize";
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  html, body {
    width: 100%;
  }

  /**
   * 16px
   */
  body {
    padding: 0;
    font-family: $body-font;
    font-size: $body-font-size;
    color: $grey-800;
    margin: 0;
  }

  a {
    color: $blue;
    &:hover {
      color: $purple;
    }
  }

  .layout {
    flex-direction: row;
    max-width: $layout-width;
    justify-content: center;
    flex-flow: row wrap;
    margin: 0 auto 4rem;
    display: flex;
  }

  @media (max-width: ($layout-width + 50px)) {
    .layout {
      margin: 0 1rem;
    }
  }

  /**
   * Header
   */
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
  }

  /**
   * Title
   */
  .title {
    grid-template-areas: "a b";
    font-family: $lora-font;
    align-items: center;
    padding: 1rem 0;
    display: grid;

    /**
     * 18px
     */
    &__one {
      grid-area: b;
      padding-left: 1rem;
      font-family: $lora-font;
      font-size: 1.125rem;
      font-style: italic;
      font-weight: 300;
      display: block;

      a {
        text-decoration: none;
        color: inherit;
      }
    }

    /**
     * 22px
     */
    &__two {
      display: block;
      font-weight: bold;
      font-family: $lora-font;
      border-right: 1px solid #000;
      text-transform: uppercase;
      padding-right: 1rem;
      line-height: 1.4rem;
      font-size: 1.4rem;
      grid-area: a;
    }
  }

  @media (max-width: 800px) {
    .title {
      &__one { padding: 0; }
      &__two {
        display: none;
      }
    }
  }

  /**
   * Nav
   */
  .nav {
    ul {
      padding: 0;
      text-align: right;
      list-style-type: none;
      margin: 0;

      li {
        display: inline-block;
      }
    }

    &__item {
      a {
        text-decoration: none;
        font-size: $navigation-font-size;
        font-family: $navigation-font-family;
        font-weight: $navigation-font-weight;
        text-transform: uppercase;
        padding: 1rem .5rem;
        display: block;
        color: inherit;

        &:hover {
          color: $orange;
        }
      }

      &:last-child {
        a {
          padding-right: 0;
        }
      }
    }
  }
</style>

<static-query>
  query {
    meta: metadata {
      subTitle: siteSubTitle
      title: siteTitle
      nav: siteNav {
        id
        title
        to
      }
    }
  }
</static-query>
