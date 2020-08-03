
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
    font-size: 100%;
    width: 100%;
  }

  body {
    padding: 0;
    color: var(--grey-800);
    font-family: var(--system-font-family);
    letter-spacing: -0.02rem;
    margin: 0;
  }

  a {
    color: var(--blue-500);
    &:hover {
      color: var(--purple-500);
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
    margin: 0 auto 4rem;
    flex-flow: row wrap;
    display: flex;
  }

  @media (max-width: $medium-screen) {
    .layout {
      width: auto;
      margin: 0 1rem;
    }
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;

    .header__title {
      align-items: center;
      font-family: var(--lora-font-family);
      grid-template-areas: "a b";
      padding: 1rem 0;
      display: grid;

      .header__title--main {
        grid-area: b;
        padding-left: 1rem;
        font-style: italic;
        font-family: var(--lora-font-family);
        font-size: 1.125rem;
        display: block;

        a {
          text-decoration: none;
          color: inherit;
        }
      }

      .header__title--sub {
        font-size: 1.4rem;
        font-weight: bold;
        line-height: 1.4rem;
        border-right: 1px solid var(--grey-800);
        font-family: var(--lora-font-family);
        text-transform: uppercase;
        padding-right: 1rem;
        font-style: inherit;
        display: block;
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
        color: inherit;
        text-decoration: none;
        font-family: var(--system-font-family);
        padding: 1rem .5rem;
        font-size: 0.96rem;
        display: block;

        &:hover {
          color: var(--orange-600);
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
