require "spec_helper"
require 'pry'

describe Spree::Payment do

  let(:payu_payment) { create(:payu_payment) }
  let(:payment) { create(:payment) }
  context "process payments" do
    context "#process!" do
      context "if payment_method is Spree::Gateway::PayuInGateway" do
        it "calls process_with_payu" do
          expect(payu_payment).to receive(:process_with_payu)
          payu_payment.process!
        end
      end

      context "if payment_method is not Spree::Gateway::PayuInGateway" do
        it "calls default method" do
          expect(payment).not_to receive(:process_with_payu)
          payment.process!
        end
      end
    end

    context "#process_with_payu" do
      it "process payu payments" do
        allow(payu_payment).to receive(:process_purchase).and_call_original
        expect(payu_payment.state).to eq 'checkout'
        payu_payment.process_with_payu

        expect(payu_payment.state).to eq 'completed'
        expect(payu_payment.capture_events.present?).to be_truthy
      end

    end

  end

  context "cancel payments" do
    context "#cancel!" do
      it "calls cancel_with_payu If PaymentMethod == PayUMoney" do
        expect(payu_payment).to receive(:cancel_with_payu)
        payu_payment.cancel!
      end

      it "calls default method If PaymentMethod != PayUMoney" do
        expect(payment).not_to receive(:cancel_with_payu)
        payment.cancel!
      end

    end

    context "#cancel_with_payu" do
      it "cancels payu payment" do
        allow(payu_payment).to receive(:handle_response).with(an_instance_of(ActiveMerchant::Billing::Response), :void, :failure).and_return(true)
        expect(payu_payment.cancel_with_payu).to be_truthy
      end
    end

    context "#void_payemnt" do
      let(:payment_method) { payu_payment.payment_method }
      it "makes the payment void" do
        allow(payment_method).to receive(:cancel).with(payu_payment.transaction_id).and_call_original
        expect(payu_payment.void_payment).to be_kind_of(ActiveMerchant::Billing::Response)
      end
    end
  end
end