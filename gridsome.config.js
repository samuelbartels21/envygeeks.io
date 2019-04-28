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
  headers: {
    link: [
      {
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css?family=" + [
          "Lora:300,300i,400,400i",
          "Montserrat:300,300i,400,400i,700,700i",
          "Noto+Sans:400,400i",
          "IBM+Plex+Mono:400"
        ].join("|")
      }
    ]
  },
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
  },
  skipOnMeta: [
    "headers",
    "transformers",
    "plugins"
  ],
}
