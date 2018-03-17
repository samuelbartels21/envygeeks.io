(() => {
  loadAnalytics = () => {
    if ((jekyll.production || jekyll.debug) && site.data.ga.id) {
      if (navigator.userAgent.indexOf("Speed Insights") == -1) {
        window.dataLayer = window.dataLayer || [];
        function gtag(){
          dataLayer.push(arguments);
        }

        gtag("js", new Date());
        gtag("config", site.data.ga.id);
      }
    }
  }
})();
