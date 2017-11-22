(() => {
  loadStripe = () => {
    var stripe = StripeCheckout.configure({
      locale: site.data.stripe.locale,
      zipCode: site.data.stripe.zip_code,
      bitcoin: site.data.stripe.bitcoin,
      image: site.data.stripe.image,
      token: (token) => {},

      key: jekyll.development ? site.data.stripe.test_key :
        site.data.stripe.production_key
    });

    /**
     * Open the Window.
     * Accept the Payment.
     * Process it.
     */
    document.querySelectorAll(".donate").forEach((v) => {
      v.addEventListener("click", (e) => {
        e.preventDefault();
        stripe.open({
          name: site.data.stripe.checkout.name,
          description: site.data.stripe.checkout.description,
          amount: site.data.stripe.checkout.amount
        });
      });
    });

    /**
     * Close any open Popup.
     * No need to freak out yeah?
     * It's okay!
     */
    window.addEventListener("popstate", () => {
      handler.close()
    })
  }
})();
