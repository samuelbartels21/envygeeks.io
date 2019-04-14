<template>
  <a :href="url" rel="noopener noreferrer nofollow" target="_blank">
    <slot/>
  </a>
</template>

<script>
  export default {
    name: "ExternalLink",
    props: [
      "url"
    ]
  }
</script>
