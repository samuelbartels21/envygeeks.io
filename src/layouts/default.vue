<template>
  <div class=layout>
    <header class=header>
      <div class=title>
        <span class=title__one>
          <g-link to="/" rel="me">
            {{ $static.meta.title }}
          </g-link>
        </span>
        <span class=title__two>
          {{ $static.meta.sub_title }}
        </span>
      </div>
      <nav class=nav>
        <ul>
          <li class=nav__item v-for="nav in $static.meta.nav" :key="nav.id">
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

<script>
export default {
  metaInfo: {
    bodyAttrs: {
      class: "body"
    }
  }
}
</script>

<static-query>
query {
  meta: metaData {
    sub_title: siteSubTitle
    title: siteTitle
    nav: siteNav {
      id
      title
      to
    }
  }
}
</static-query>

<style lang="scss">

  /**
   * 16px
   */
  .body {
    padding: 0;
    font-size: 100%;
    font-family: "Lora";
    color: #091f2f;
    margin: 0;
  }

  .layout {
    max-width: 750px;
    flex-direction: row;
    justify-content: center;
    flex-flow: row wrap;
    margin: 0px auto;
    display: flex;
  }

  /**
   * Header
   */
  .header {
    display: flex;
    border-bottom: 1px dashed #e7eaf3;
    justify-content: space-between;
    align-items: center;
    width: 100%;
  }

  /**
   * Title
   */
  .title {
    font-family: "Noto Sans";
    grid-template-areas: "a b";
    align-items: center;
    padding: 1rem 0;
    display: grid;

    /**
     * 18px
     */
    &__one {
      grid-area: b;
      padding-left: 1rem;
      font-family: "Lora";
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
      font-family: "Montserrat";
      border-right: 1px solid #000;
      text-transform: uppercase;
      padding-right: 1rem;
      line-height: 1.4rem;
      font-size: 1.4rem;
      grid-area: a;
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
        font-size: 0.875rem;
        text-decoration: none;
        font-family: "Montserrat";
        text-transform: uppercase;
        padding: 1rem .5rem;
        display: block;
        color: inherit;

        &:hover {
          color: #d676aa;
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
