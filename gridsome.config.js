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
    meta: [
      {
        name: "HandheldFriendly",
        content: "True"
      },
      {
        "http-equiv": "X-UA-Compatible",
        content: "IE=edge"
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
