<template>
  <BaseLayout>
    <main :class="mainClassName">
      <slot/>
    </main>
  </BaseLayout>
</template>

<script>
  export default {
    name: "Post",
    props: {
      many: {
        default: false,
        required: false,
        type: Boolean
      }
    },
    computed: {
      mainClassName() {
        if (this.many) return "content posts";
        return "content";
      }
    }
  };
</script>

<style lang="scss">
  .content {
    width: 100%;
    float: left;
  }
</style>
