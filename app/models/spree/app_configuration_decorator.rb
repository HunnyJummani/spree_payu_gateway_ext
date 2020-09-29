Spree::AppConfiguration.class_eval do
  preference :payu_bolt_checkout, :boolean, default: false
end
