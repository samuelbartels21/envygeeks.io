<template>
  <a :href="href" rel="noopener noreferrer nofollow" target="_blank">
    <slot/>
  </a>
</template>

<script>
  export default {
    name: "a-ext",
    props: {
      href: {
        required: true,
        type: String
      }
    }
  }
</script>
