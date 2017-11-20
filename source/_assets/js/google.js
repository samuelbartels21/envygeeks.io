(function() {
  if (jekyll.production) {
    if (navigator.userAgent.indexOf("Speed Insights") == -1) {
      window.ga = window.ga || function() { (ga.q = ga.q || []).push(arguments) }

      ga.l = +new Date;
      ga("create", site.data.ga.id, "auto");
      ga("send", "pageview");
    }
  }
})();
