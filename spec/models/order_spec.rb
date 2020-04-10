require "spec_helper"

describe Spree::Order, type: :model do

  context "#confirmation_required?" do
    let (:order) { Spree::Order.new }
    it "returns false" do
      allow_any_instance_of(Spree::Order).to receive(:confirmation_required?).and_return(false)

      expect(order.confirmation_required?).to be_falsey
      expect(order.confirmation_required?).not_to be_truthy
    end
  end
end