<template>
  <BaseLayout>
    <main class="content page">
      <header v-if="pageTitle" class="page__title">
        <h1>{{ pageTitle }}</h1>
      </header>
      <slot/>
    </main>
  </BaseLayout>
</template>

<style lang="scss">
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  .page {
    margin: 3rem 0;
    font-size: var(--page-font-size);
    line-height: var(--page-line-height);
    font-family: var(--page-font-family);
    color: var(--page-color);
    float: left;

    p {
      margin: 2rem 0;
      padding: 0;
    }

    &__title {
      h1 {
        font-family: var(--page-title-font);
        text-align: var(--page-title-alignment);
        line-height: var(--page-title-line-height);
        font-style: var(--page-title-text-style);
        font-size: var(--page-title-font-size);
        margin: 0 0 3rem;
      }
    }
  }
</style>

<script>
  export default {
    props: {
      pageTitle: {
        required: false,
        type: String
      }
    }
  };
</script>
