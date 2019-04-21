<template>
  <Layout>
    <main role=main :class="many ? 'content posts' : 'content'">
      <slot/>
    </main>
  </Layout>
</template>

<script>
  import Layout from "~/layouts/Default.vue"
  export default {
    name: "Post",
    components: {
      Layout
    },

    props: [
      "many"
    ]
  }
</script>
