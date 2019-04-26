<template>
  <Layout>
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
      height=200
      alt="Jordon Bedwell Avatar"
      src="~/assets/avatars/envygeeks.jpg"
      class="avatar"
      width=200
    />

    <p>Hi, I’m Jordon Bedwell. I’m an Open Source Programmer, Programmer For
    Hire, a systems person. I’m also a firm believer in Time Travel. I love
    Doctor Who, Family Guy, Downton Abbey, and helping people as much as I can.
    You might know me, you probably don’t. I’m sure I’ve touched a project that
    you’ve used before, knowingly or not, and I plan to keep helping out Open
    Source for as long as I can, because everybody deserves high quality Open
    Source software. It’s even how I’m trying to make a living.</p>

    <p>In the past it was my day to day job to scale things like Jekyll builds
    across large Docker (and later Kubernetes) clusters to thousands of builds
    at once. I also programmed applications that many users used between there,
    and those systems. No, not at Github, somewhere else. I am also often hired
    to do custom Jekyll work, like teaching people how to get Jekyll to play
    well in a large org, or to build plugins to make life easier when working
    with Jekyll. When doing freelance work most people hire me to do initial ops
    work, Rails apps, and even systems programming with languages like Go, and
    Rust. If you were to ask me what I do, I would say I “hack”, because I work
    on my different things!</p>

    <h2>Skills</h2>
    <div class="skills">
      <div class="skills__set">
        <h3>OS's</h3>
        <ul>
          <li>macOS</li>
          <li>Alpine Linux</li>
          <li>Ubuntu GNU+Linux</li>
          <li>Ubuntu Cloud</li>
          <li>OpenBSD</li>
        </ul>
      </div>
      <div class="skills__set">
        <h3>Clouds</h3>
        <ul>
          <li>AWS</li>
          <li>Heroku</li>
          <li>Digital Ocean</li>
          <li>Linode</li>
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
    </div>

    <g-image
      class="hacking"
      src="~/assets/gifs/hacking.gif"
      id="hacking"
    />

    <p>I am heavy <ExternalLink url="https://docker.com">Docker</ExternalLink>
    user, a Linux user, and I manage and maintain a great many <ExternalLink
    url="https://jekyllrb.com">Jekyll</ExternalLink> plugins, and other Ruby
    projects, that hopefully you love and enjoy. I’ve built tools like
    <GithubLink repo="docker-template"/>Docker Template</GithubLink>, plugins
    like <GithubLink repo="jekyll-assets">Jekyll Assets</GithubLink>, and Docker
    zimages like <GithubLink repo="jekyll-docker">Jekyll Docker</GithubLink>,
    and I currently manage many other Docker images. Unless I’ve removed them,
    or planned to deprecate them because the ecosystem has taken over to do a
    better job.</p>
  </layout>
</template>

<script>
  import GithubLink from "~/components/GithubLink.vue"
  import ExternalLink from "~/components/ExternalLink.vue";
  import DonutChart from "~/components/DonutChart.vue";
  import Layout from "~/layouts/Page.vue";

  export default {
    components: {
      DonutChart,
      ExternalLink,
      GithubLink,
      Layout
    },

    metaInfo: {
      title: "About Me: Jordon Bedwell",
    }
  };
</script>

<style lang=scss>
  @import "~/assets/colors.scss";

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
      margin: 2rem 0;
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
    padding: 2.8rem 1rem 0 0;
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
</style>
