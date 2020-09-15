module Spree
  class PayuDetail < Spree::Base
    belongs_to :payment, class_name: 'Spree::Payment', optional: true
    belongs_to :order, class_name: 'Spree::Order'
  end
end
