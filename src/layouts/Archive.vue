<template>
  <Layout :many=true>
    <slot/>
  </Layout>
</template>
<script>
  import Layout from "~/layouts/Post.vue"
  export default {
    components: {
      Layout
    }
  }
</script>
