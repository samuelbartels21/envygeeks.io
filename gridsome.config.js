vars = require("./src/assets/vars.js");

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
      use: '@gridsome/plugin-critical',
      options: {
        width: parseInt(vars.layoutWidth),
        paths: [
          '/'
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
