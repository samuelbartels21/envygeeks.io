<template>
  <Layout :page-title=pageTitle :page-title-in-header=pageTitleInHeader>
    <main class="content page">
      <header class=page__title>
        <h1>{{ pageTitle }}</h1>
      </header>
      <slot/>
    </main>
  </Layout>
</template>

<script>
  import Layout from "~/layouts/Default.vue"
  export default {
    components: {
      Layout
    },

    props: [
      "pageTitleInHeader",
      "pageTitle"
    ]
  }
</script>

<style lang=scss>
  @import "~/assets/colors.scss";

  .page {
    font-size: 1.125rem;
    line-height: 2.5rem;
    color: $grey8;

    p {
      margin: 2rem 0;
      padding: 0;
    }

    &__title {
      h1 {
        font-size: 3rem;
        line-height: 4rem;
        text-align: center;
        font-style: italic;
        margin: 3rem 0;
      }
    }
  }
</style>
