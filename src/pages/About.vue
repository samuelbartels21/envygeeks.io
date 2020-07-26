<template>
  <PageLayout page-title="About Me">
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
    <div class="percentages">
      <p class=percentage__item>
        <span class=percentage__item--numb>56%</span>
        <span class=percentage__item--name>
          Ruby
        </span>
      </p>
      <p class=percentage__item>
        <span class=percentage__item--numb>21%</span>
        <span class=percentage__item--name>
          JavaScript
        </span>
      </p>
      <p class=percentage__item>
        <span class=percentage__item--numb>17%</span>
        <span class=percentage__item--name>
          GoLang
        </span>
      </p>
      <p class=percentage__item>
        <span class=percentage__item--numb>6%</span>
        <span class=percentage__item--name>
          Other
        </span>
      </p>
    </div>

    <div class=skills>
      <div class=skills__set>
        <h3>OS's</h3>
        <ul>
          <li>macOS</li>
          <li>Alpine Linux</li>
          <li>Ubuntu GNU+Linux</li>
          <li>OpenBSD</li>
        </ul>
      </div>
      <div class=skills__set>
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
          <li class="empty small">
            <!-- Empty -->
          </li>
          <li class="empty small">
            <!-- Empty -->
          </li>
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
          <li class="empty large">
            <!-- Empty -->
          </li>
          <li class="empty large">
            <!-- Empty -->
          </li>
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
          <li class=empty>
            <!-- Empty -->
          </li>
          <li class=empty>
            <!-- Empty -->
          </li>
          <li class=empty>
            <!-- Empty -->
          </li>
        </ul>
      </div>
    </div>

    <g-image
      class="hacking"
      src="../assets/hacking.gif"
      id="hacking"
    />

    <p>I'm a <a-ext href="https://kubernetes.io" text="Kubernetes"/> user, a Linux
    & Unix user, and mail a Ruby programmer, I also maintain a great many
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

<style lang="scss" scoped>
  @import "../components/scss/colors";
  @import "../components/scss/vars";

  h2 {
    border-bottom: 1px dashed var(--grey-400);
    padding-bottom: 1rem;
  }

  .percentages {
    border-radius: 6px;
    background-color: var(--grey-200);
    box-shadow: 1px 4px 2px var(--grey-100);
    border: 1px solid var(--grey-400);
    grid-template-areas: 'a b c d';
    display: grid;

    .percentage__item {
      display: inline-block;
      border-right: 1px solid var(--grey-600);
      text-align: center;

      .percentage__item--name {
        color: var(--blue-800);
        display:block;
      }

      .percentage__item--numb {
        font-size: 2rem;
        color: var(--purple-800);
        display: block;
      }

      &:last-child {
        border-right: none;
      }
    }
  }

  .hacking {
    width: 100%;
    height: auto;
  }

  .avatar {
    height: 8.3rem;
    margin: .5rem 1.2rem 0 0;
    width: 8.3rem;
    float: left;

  }

  .skills {
    grid-template-areas: 'a b c';
    border: 1px solid var(--grey-400);
    background-color: var(--grey-200);
    border-radius: 6px;
    margin: 2rem 0;
    display: grid;

    .skills__set {
      border-bottom: 1px solid var(--grey-400);

      ul {
        padding: 0;
        list-style-position: inside;
        margin: 0;

        li {
          list-style-type: none;
          border-bottom: 1px solid var(--grey-300);
          border-right: 1px solid var(--grey-300);
          padding: 0.4rem 1rem;

          &:last-child {
            border-bottom: none;
          }
        }
      }

      h3 {
        padding: 1rem;
        font-size: 1rem;
        letter-spacing: -1px;
        font-family: var(--poppins-font-family);
        border-right: 1px solid var(--grey-400);
        border-bottom: 1px solid var(--grey-400);
        box-shadow: 0 1px 2px var(--grey-300);
        background-color: var(--grey-300);
        font-weight: bold;
        color: $orange;
        margin: 0;
      }

      .empty::after {
        content: " ";
        white-space: pre;
      }
    }
  }

  @media (min-width: $small-screen) {
    .skills {
      .skills__set {
        &:nth-child(3),
        &:nth-child(6) {
          ul {
            li {
              border-right: none;
            }
          }

          h3 {
            border-right: none;
          }
        }
      }

      .skills__set:nth-child(3) ~ div {
        border-bottom: none;
      }
    }

    .small {
      display: none;
    }
  }

  @media (max-width: $medium-screen) {
    .avatar {
      width: 5rem;
      height: 5rem;
    }
  }

  @media (max-width: $small-screen) {
    .skills {
      grid-template-areas: 'a b';
      .skills__set {
        &:nth-child(2),
        &:nth-child(4),
        &:nth-child(6) {
          ul {
            li {
              border-right: none;
            }
          }

          h3 {
            border-right: none;
          }
        }
      }

      .skills__set:nth-child(4) ~ div {
        border-bottom: none;
      }
    }

    .large {
      display: none;
    }
  }
</style>
