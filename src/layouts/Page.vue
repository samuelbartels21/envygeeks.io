<template>
  <Base>
    <main role="main" class="content page">
      <header v-if="pageTitle" class="page__title">
        <h1>{{ pageTitle }}</h1>
      </header>
      <slot/>
    </main>
  </Base>
</template>

<style lang="scss">
  @import "~/assets/colors.scss";

  .page {
    font-size: 1.125rem;
    line-height: 2.5rem;
    margin: 3rem 0;
    color: $grey8;
    float: left;

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
