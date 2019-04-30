<template>
  <div v-if="!on" class="expandable-wrapper" data-expanded="false">
    <a v-on:click="onClick" class="button">
      <g-image
        class="in"
        height="24"
        src="~/assets/in.svg"
        immediate="true"
        alt="Contract"
        width="24"
      />

      <g-image
        class="out"
        height="24"
        src="~/assets/out.svg"
        immediate="true"
        alt="Expand"
        width="24"
      />
    </a>

    <slot />
  </div>
</template>

<script>
  import Vue from "vue"
  const opts = {
    name: "Expandable",
    methods: {
      onClick(event) {
        // this.$el is pretty buggy tbqf
        let state = this.$el.getAtrribute("data-expanded")
        if (state === "true") {
          el.setAttribute(
            "data-expanded",
            false
          )
        } else {
          if (state === "false") {
            el.setAttribute(
              "data-expanded",
              true
            )
          }
        }
      }
    },
    props: {
      on: {
        required: false,
        type: Object
      }
    }
  }

  export default opts

  /**
   * expandOn an element
   * @param ctx [Object] current this
   * @param el [Object] the current element
   * @param selector [String] the selector
   * @note instead of using the Component
   * @return [null]
   */
  export function expandOn(ctx, el, sel) {
    let els = el.querySelectorAll(sel)
    els.forEach(child => {
      let Component = Vue.extend(opts)
      let component = new Component({
        parent: ctx
      })

      component.$mount()
      child.parentNode.insertBefore(component.$el, child)
      component.$el.appendChild(child)
    })
  }
</script>

<style lang="scss" scoped>
  @import "~/assets/colors.scss";

  .button {
    font-size: 10em;
    display: block;

    > img {
      &:hover {
        fill: $blue;
      }
    }
  }

  .expandable-wrapper {
    &[data-expanded=true] {
      .button {
        .out { display: none; }
        .in  {
          display: block;
        }
      }
    }

    &[data-expanded=false] {
      .button {
        .out { display: block; }
        .in  {
          display: none;
        }
      }
    }
  }
</style>
