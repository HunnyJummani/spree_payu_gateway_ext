require "spec_helper"

describe Spree::Gateway::PayuInGateway do
 let(:gateway) { create(:payu_payment_gateway) }

  context "#method_type" do
    it "returns method type" do
      expect(gateway.method_type).to eq 'payu_in'
      expect(gateway.method_type).not_to eq 'payuingateway'
    end
  end

  context "#provider_class" do
    it "is a PayuIn gateway" do
     expect(gateway.provider_class).to eq ActiveMerchant::Billing::PayuInGateway
    end
  end

  context "#actions" do
    it "allows actions to be performed" do
      expected_actions = %w[credit]
      result = gateway.actions

      expect(result).to be_instance_of(Array)
      expect(result).to match_array(expected_actions)

      expect(result).not_to include(:void)
    end
  end

  context "#payment_profiles_supported?" do
    it 'returns false' do
      expect(gateway.payment_profiles_supported?).to be_falsey

      expect(gateway.payment_profiles_supported?).not_to be_truthy
    end
  end

  context "#source_required?" do
    it "returns false as no source required" do
      expect(gateway.source_required?).to be_falsey

      expect(gateway.source_required?).not_to be_truthy
    end
  end

  context "#auto_capture?" do
    it "returns true as autocaptures the payment" do
      expect(gateway.auto_capture?).to be_truthy

      expect(gateway.auto_capture?).not_to be_falsey
    end
  end

  context "#purchase" do
    it "returns canned response" do
      expect(gateway.purchase(1999, 'credit_card')).to be_kind_of(ActiveMerchant::Billing::Response)
    end
  end

  context "#credit" do
    it "credits the refund amount if authorized" do
      allow(gateway).to receive_message_chain(:provider, :refund).and_return(mock_success_response)

      result = gateway.credit(1999, '403993715520830822')

      expect(result.success?).to be_truthy
      expect(result.success?).not_to be_falsey
      expect(result.message).to eq 'PayUIn Gateway: refund success'
    end

    it "does not credit refund amount if not authorized" do
      allow(gateway).to receive_message_chain(:provider, :refund).and_return(mock_fail_response)

      result = gateway.credit(1999, '430993715520830822')

      expect(result.success?).to be_falsey
      expect(result.success?).not_to be_truthy
      expect(result.message).to eq 'PayUIn Gateway: refund failed'
    end

  end

  context "#cancel" do
    it "cancels the order and refunds the payment" do
      expect(gateway.cancel('123456789')).to be_instance_of(ActiveMerchant::Billing::Response)
    end
  end

  context "#test?" do
    it "returns the test mode from payment method preferences" do
      expect(gateway.test?).to be_truthy
      expect(gateway.test?).not_to be_falsey
    end
  end
end

def mock_success_response
  ActiveMerchant::Billing::Response.new(true, 'PayUIn Gateway: refund success', {},
                                            test: true,
                                            authorization: '403993715520830822')
end

def mock_fail_response
  ActiveMerchant::Billing::Response.new(false, 'PayUIn Gateway: refund failed', {},
                                            test: true,
                                            authorization: '430993715520830822')
end
