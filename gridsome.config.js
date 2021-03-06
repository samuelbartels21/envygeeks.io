module.exports = {
  myName: "Jordon Bedwell",
  twitterUser: "envygeeks",
  siteName: "Jordon Bedwell - EnvyGeeks",
  siteDescription: "The website of Jordon Bedwell",
  readMoreIdentifier: "<!-- MORE -->",
  siteTitle: "Jordon Bedwell",
  siteSubTitle: "EnvyGeeks",
  githubUser: "envygeeks",
  siteUrl: "envygeeks.io",
  titleTemplate: "%s",
  useSSL: true,
  permalinks: {
    trailingSlash: false
  },
  icon: {
    touchicon: null,
    favicon: null
  },
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
        typeName: "Post",
        refs: {
          author: {
            typeName: "Author",
            create: false
          },
          tags: {
            typeName: "Tag",
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
  templates: {
    Post: "/blog/:year/:month/:day/:title",
    Tag: "/tag/:id"
  },
  transformers: {
    remark: {
      externalLinksTarget: "_blank",
      externalLinksRel: [
        "nofollow",
        "noreferrer",
        "noopener"
      ],
      autolinkHeadings: {
        behavior: 'wrap',
        content: {
          type: 'element',
          tagName: 'span',
          properties: {
            className: [
              'this', 'is', 'disabled'
            ]
          }
        }
      },
      plugins: [
        [
          "@gridsome/remark-prismjs", {
            // Next Release -- showLineNumbers: true
          }
        ]
      ]
    }
  },
  skipOnMeta: [
    "headers",
    "transformers",
    "plugins"
  ]
}
