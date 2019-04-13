module.exports = {
  siteName: "envygeeks.io",
  plugins: [
    {
      use: '@gridsome/source-filesystem',
      options: {
        path: 'src/posts/**/*.md',
        route: '/blog/:year/:month/:day/:slug',
        typeName: 'post',
        refs: {
          tags: {
            typeName: 'tag',
            route: '/tag/:id',
            create: true
          }
        }
      }
    },
    {
      use: "@gridsome/source-filesystem",
      options: {
        route: "/:slug",
        path: "src/pages/**/*.md",
        typeName: 'page',
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
