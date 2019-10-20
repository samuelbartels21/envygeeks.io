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
    font-size: $font-size;
    line-height: $line-height;
    margin: 3rem 0;
    color: $grey8;
    float: left;

    p {
      margin: 2rem 0;
      padding: 0;
    }

    &__title {
      h1 {
        text-align: center;
        line-height: $page-header-line-height;
        font-size: $page-header-font-size;
        font-style: italic;
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
