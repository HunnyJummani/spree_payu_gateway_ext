require "spree/testing_support/factories"

FactoryBot.define do
  factory :payu_payment_gateway, class: Spree::PaymentMethod do
    type { 'Spree::Gateway::PayuInGateway' }
    name { 'PayUMoney' }
    active { true }
    display_on { 'both' }
    auto_capture { true }
    preferences { { key_salt: "eCwWELxi",  merchant_key: "gtKFFx", server: "test", test_mode: true } }
  end
end