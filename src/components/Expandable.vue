<template>
  <div class="expandable-wrapper" data-expanded="false">
    <a v-on:click="onClick" class="button">
      <g-image
        class="in"
        height="24"
        src="~/assets/in.svg"
        alt="Contract"
        width="24"
      />

      <g-image
        class="out"
        height="24"
        src="~/assets/out.svg"
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
      onClick
    },
    props: {
      on: {
        required: false,
        type: Object
      }
    }
  }

  /**
   * onClick allows us to expand and
   * contract the given element passed from
   * upstream to us via the modal
   * @return [null]
   */
  function onClick(event) {
    let el = this.$el, state = el.getAttribute("data-expanded")
    if (state === "true") {
      el.setAttribute("data-expanded",
        false
      )
    } else {
      if (state == "false") {
        el.setAttribute("data-expanded",
          true
        )
      }
    }
  }

  /**
   * setup allows you to set this component
   * up wherever you wish in a programatic way
   * without much effort at all.
   * @return [null]
   */
  export default opts
  export function expandOn(ctx, el, selector) {
    let els = el.querySelectorAll(selector)
    els.forEach(sEl => {
      let Component = Vue.extend(opts)
      let eac = new Component({
        parent: ctx
      })

      eac.$mount()
      sEl.parentNode.insertBefore(eac.$el, sEl)
      eac.$el.appendChild(sEl)
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
