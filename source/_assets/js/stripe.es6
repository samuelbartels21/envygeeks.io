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
    })

    /**
     * Open the Window.
     * Accept the Payment.
     * Process it.
     */
    site.data.stripe.checkout.forEach((v) => {
      document.querySelectorAll("[data-stripe-slug=" + v.slug + "]").forEach((sv) => {
        sv.addEventListener("click", (e) => {
          e.preventDefault();
          stripe.open({
            name: v.name,
            currency: v.currency,
            description: v.description,
            amount: v.amount
          })
        })
      })
    })

    /**
     * Close any open Popup.
     * No need to freak out yeah?
     * It's okay!
     */
    window.addEventListener("popstate", () => {
      stripe.close()
    })
  }
})()
