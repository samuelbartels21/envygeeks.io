<template>
  <div ref="content" :class="className" :id="id">
    <slot/>
  </div>
</template>

<script>
  export default {
    name: "Excerpt",
    props: {
      limit: Number,
      className: String,
      id: String
    },
    mounted() {
      if (this.limit === Infinity) return;
      while (this.$el.childNodes.length > this.limit) {
        this.$el.removeChild(
          this.$el.lastChild
        );
      }
    }
  }
</script>
