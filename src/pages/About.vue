<template>
  <PageLayout page-title="About Me">
    <DonutChart class="chart__programming"
      :labels="[
        'Ruby',
        'JavaScript',
        'Other',
        'Go'
      ]"

      :values="[
        60,
        15,
        5,
        20
      ]"
    />

    <g-image
      height="200"
      alt="Jordon Bedwell Avatar"
      src="../assets/envygeeks.jpg"
      class="avatar"
      width="200"
    />

    <p>Hey, I’m Jordon Bedwell. I’m a programmer, and systems person for
    hire. I’m also a firm believer in Time Travel. I love  Doctor Who, Family Guy,
    Downton Abbey, and helping people achieve their goals as much as I can. You
    might know me, you probably don’t. I’m sure I’ve touched  a project that
    you’ve used before, knowingly or not, and I plan to keep helping out
    Open Source for as long as I can, because everybody deserves
    high quality open source software.</p>

    <h2>Skills</h2>
    <div class="skills">
      <div class="skills__set">
        <h3>OS's</h3>
        <ul>
          <li>macOS</li>
          <li>Alpine Linux</li>
          <li>Ubuntu GNU+Linux</li>
          <li>OpenBSD</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>Clouds</h3>
        <ul>
          <li>AWS</li>
          <li>Heroku</li>
          <li>Digital Ocean</li>
          <li>GCE</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>Containers</h3>
        <ul>
          <li>Docker</li>
          <li>Kubernetes</li>
          <li>ECS</li>
          <li>LXD</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>API's</h3>
        <ul>
          <li>Stripe</li>
          <li>MailChimp</li>
          <li>Phillips Hue</li>
          <li>Github</li>
          <li>AWS</li>
          <li>GCE</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>Programming</h3>
        <ul>
          <li>Ruby</li>
          <li>Rust</li>
          <li>POSIX Sh</li>
          <li>JavaScript</li>
          <li>TypeScript</li>
          <li>Python</li>
          <li>Bash</li>
          <li>Go</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>Frameworks</h3>
        <ul>
          <li>React</li>
          <li>Jekyll</li>
          <li>Ruby on Rails</li>
          <li>Hanami</li>
          <li>jQuery</li>
        </ul>
      </div>
    </div>

    <g-image
      class="hacking"
      src="../assets/hacking.gif"
      id="hacking"
    />

    <p>I'm a <a-ext href="https://docker.com" text="Docker"/> user, a Linux
    & Unix user, a mainly Ruby, and Go programmer, and I maintain a great many
    <a-ext href="https://jekyllrb.com" text="Jekyll"/> plugins, and other various
    projects, that hopefully you love and enjoy. I’ve built tools like <a-gh
    repo="docker-template" name="Docker Template"/>, plugins like <a-gh
    repo="jekyll-assets" name="Jekyll Assets"/>, and Docker images like <a-gh
    repo="jekyll-docker" name="Jekyll Docker"/>, and I currently manage many
    other Docker images. Unless I’ve removed them, or planned to deprecate
    them because the ecosystem has taken over to do a better job.</p>
  </PageLayout>
</template>

<script>
  import DonutChart from "../components/charts/Donut"
  import PageLayout from "../layouts/Page"

  export default {
    components: {
      DonutChart,
      PageLayout
    },
    metaInfo: {
      title: "About Me: Jordon Bedwell",
    }
  }
</script>

<style lang="scss">
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  h2 {
    border-bottom: 1px dashed $grey3;
    padding-bottom: 1rem;
  }

  /**
   * Chart
   * First
   */
  .chart {
    &__programming {
      width: 240px;
      text-align: right;
      shape-outside: circle();
      border-radius: 50%;
      margin: 1rem 0;
      height: 240px;
      float: right;
    }
  }

  /**
   * Clara Oswald
   * GIF
   */
  .hacking {
    width: 100%;
    height: auto;
  }

  /**
   * First IMG
   * Avatar
   */
  .avatar {
    height: 8.3rem;
    padding: .8rem 1rem 0 0;
    width: 8.3rem;
    float: left;

  }

  /**
   * Skills list
   */
  .skills {
    padding-bottom: 1rem;
    grid-template-areas: 'a b c';
    border-bottom: 1px dashed $grey3;
    margin-bottom: 2rem;
    display: grid;

    &__set {
      ul {
        margin: 0;
        list-style-position: inside;
        padding: 0;
      }

      h3 {
        color: $orange;
      }
    }
  }

  @media (max-width: 800px) {
    .chart {
      &__programming {
        width: 8rem;
        margin-top: 1rem;
        height: 8rem;
      }
    }

    .avatar {
      width: 5rem;
      height: 5rem;
    }
  }

  @media (max-width: 520px) {
    .skills {
      grid-template-areas: 'a b';
    }
  }
</style>
