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

<style lang="scss" scoped>
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  .page {
    margin: 3rem 0;
    font-size: 1.06rem;
    color: var(--grey-800);
    line-height: 1.9rem;
    float: left;

    p {
      margin: 2rem 0;
      padding: 0;
    }

    .page__title {
      h1 {
        margin: 0 0 3rem;
        text-align: center;
        font-family: var(--lora-font-family);
        font-style: italic;
        line-height: 4rem;
        font-size: 3rem;
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
