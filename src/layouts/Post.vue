<template>
  <Base>
    <main role="main" :class="mainClassName">
      <slot/>
    </main>
  </Base>
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
