/**
 * Learn more:
 * https://gridsome.org/docs/server-api
 */
module.exports = function(api) {
  api.loadSource(store => {
    store.addMetaData("githubUser", "envygeeks")
    store.addMetaData("siteSubTitle", "Envygeeks")
    store.addMetaData("siteTitle", "Jordon Bedwell")
    store.addMetaData("siteUrl", "envygeeks.io")
    store.addMetaData("siteNav", [
      {
        id: 1,
        title: "Home",
        to: "/"
      },
      {
        id: 2,
        title: "About",
        to: "/about"
      }
    ])
  })
}
