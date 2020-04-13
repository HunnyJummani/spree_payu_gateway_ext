require "spree/testing_support/factories"

FactoryBot.define do
  factory :payu_payment, class: Spree::Payment, parent: :payment do
    order
    amount { 45.99 }
    response_code { '403993715520830822' }

    association :payment_method, factory: :payu_payment_gateway

    after :create do |payu_payment|
      payu_payment.source = nil
      payu_payment.save(validate: false)
      payu_payment.reload
    end
  end
end