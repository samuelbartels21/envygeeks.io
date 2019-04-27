vars = require("./src/assets/vars.base.js");

module.exports = {
  myName: "Jordon Bedwell",
  twitterUser: "envygeeks",
  siteName: "Jordon Bedwell - EnvyGeeks",
  siteDescription: "The website of Jordon Bedwell",
  siteTitle: "Jordon Bedwell",
  siteSubTitle: "EnvyGeeks",
  githubUser: "envygeeks",
  siteUrl: "envygeeks.io",
  titleTemplate: "%s",
  useSSL: true,

  /**
   * Site
   * Nav
   */
  siteNav: [
    {
      id: 1,
      title: "Home",
      to: "/"
    },
    {
      id: 2,
      title: "About",
      to: "/about"
    },
    {
      id: 3,
      title: "Archives",
      to: "/archives"
    }
  ],

  /**
   * Because Gridsome is inconsistent
   * with the way it maps out configuration
   * and meta (in that they load some
   * early, some late) we map config
   * into meta as well for a 1:1
   * type of configuration.
   */
  skipOnMeta: [
    "transformers",
    "plugins"
  ],

  plugins: [
    {
      use: "@gridsome/source-filesystem",
      options: {
        path: "src/posts/**/*.md",
        route: "/blog/:year/:month/:day/:slug",
        typeName: "Post",
        refs: {
          author: {
            typeName: "Author",
            create: false
          },
          tags: {
            typeName: "Tag",
            route: "/tag/:id",
            create: true
          }
        }
      }
    },
    {
      use: "@gridsome/source-filesystem",
      options: {
        path: "src/authors/**/*.json",
        typeName: "Author"
      }
    },
    {
      use: "@gridsome/plugin-critical",
      options: {
        width: parseInt(vars.layoutWidth),
        paths: [
          "/"
        ]
      }
    }
  ],

  transformers: {
    remark: {
      externalLinksTarget: "_blank",
      anchorClassName: "icon icon-link",
      externalLinksRel: [
        "nofollow",
        "noreferrer",
        "noopener"
      ],
      plugins: [
        "@gridsome/remark-prismjs"
      ]
    }
  }
}
