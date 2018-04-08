(() => {
  if (window.charts) {
    window.charts.forEach((v) => {
      ctx = document.getElementById(v.name).getContext("2d");
      if (ctx) {
        new Chart(ctx, v.config);
      }
    });
  }
})();
