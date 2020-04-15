require 'spec_helper'

describe Payu::PaymentHandler, type: :service do
  let(:order) { create(:order_with_line_items, number: 'R285572207') }
  let(:payment_method) { create(:payu_payment_gateway) }

  before do
    Settings.payu_in_host =  'https://test.payu.in/_payment'
  end

  context "#send_payment" do
    it "sends request to PayUMoney" do
      stub_http_request.to_return(status: 302, body: 'location')

      expect(Payu::PaymentHandler.new(payment_method: payment_method, order: order).send_payment).to be_truthy
    end

    def stub_http_request
      stub_request(:post, 'https://test.payu.in/_payment').with(body:  mock_payload)
    end
  end
end


def mock_payload
{
  key: 'gtKFFx',
  txnid: 'R285572207-5a22751633',
  amount: 19.99,
  productinfo: 'Test Porduct',
  firstname: 'Hunny',
  email: 'jummanihunny@gmail.com',
  phone: '8469057689',
  surl: "/spree/payu_handler/success",
  furl: "/spree/payu_handler/fail",
  hash: '627764cca903d01f6c4d0241beff0b65366d14bccadfa48fe76f45037bf7d9ed25b66e65308ec5f354d17a0444b0ff224dca2da94abea7e64038e65ab15b10cd'
}
end