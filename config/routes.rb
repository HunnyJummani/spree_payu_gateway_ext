Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post 'spree/payu_handler/success', to: 'payu_handler#success'
  post 'spree/payu_handler/fail', to: 'payu_handler#fail'
end
