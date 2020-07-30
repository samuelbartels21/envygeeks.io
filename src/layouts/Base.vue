
<template>
  <div class="layout">
    <header class="header">
      <div class="header__title">
        <span class="header__title--main">
          <g-link to="/" rel="me">
            {{ $static.meta.title }}
          </g-link>
        </span>
        <span class="header__title--sub">
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
  @import "../components/scss/colors";
  @import "../components/scss/external_fonts";
  @import "../components/scss/normalize";
  @import "../components/scss/vars";

  html, body {
    font-size: var(--body-font-size);
    width: 100%;
  }

  body {
    padding: 0;
    font-weight: var(--body-font-weight);
    font-family: var(--body-font-family);
    color: var(--body-color);
    margin: 0;
  }

  a {
    color: var(--anchor-color);
    &:hover {
      color: var(--anchor-hover-color);
    }
  }
</style>

<style lang=scss scoped>
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  .layout {
    flex-direction: row;
    justify-content: center;
    max-width: var(--layout-width);
    margin: var(--layout-gutter);
    flex-flow: row wrap;
    display: flex;
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;

    .header__title {
      align-items: center;
      font-family: var(--site-title-font-family);
      grid-template-areas: "a b";
      padding: 1rem 0;
      display: grid;

      .header__title--main {
        grid-area: b;
        padding-left: 1rem;
        font-style: var(--site-title-font-style);
        font-weight: var(--site-title-font-weight);
        text-transform: var(--site-title-text-transform);
        line-height: var(--site-title-line-height);
        font-family: var(--site-title-font-family);
        font-size: var(--site-title-font-size);
        display: block;

        a {
          text-decoration: none;
          color: inherit;
        }
      }

      .header__title--sub {
        display: block;
        font-size: var(--site-subtitle-font-size);
        line-height: var(--site-subtitle-line-height);
        font-weight: var(--site-subtitle-font-weight);
        border-right: 1px solid var(--site-title-splitter-color);
        text-transform: var(--site-subtitle-text-transform);
        font-family: var(--site-subtitle-font-family);
        font-style: var(--site-subtitle-font-style);
        padding-right: 1rem;
        grid-area: a;
      }
    }
  }

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

    .nav__item {
      a {
        text-decoration: none;
        font-size: var(--navigation-font-size);
        font-family: var(--navigation-font-family);
        letter-spacing: var(--navigation-letter-spacing);
        text-transform: var(--navigation-text-transform);
        font-weight: var(--navigation-font-weight);
        color: var(--navigation-color);
        padding: 1rem .5rem;
        display: block;

        &:hover {
          color: var(--navigation-hover-color);
        }
      }

      &:last-child {
        a {
          padding-right: 0;
        }
      }
    }
  }

  @media (max-width: $medium-screen) {
    .header {
      .header__title {
        .header__title--main { padding: 0; }
        .header__title--sub  {
          display: none;
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
