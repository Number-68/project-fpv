require "stripe"


Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

Rails.configuration.stripe = {
    publiishable_key: ENV["STRIPE_PUBLISHABLE_KEY"]
}
