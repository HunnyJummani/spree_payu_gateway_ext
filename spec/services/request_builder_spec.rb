require 'spec_helper'

describe Payu::RequestBuilder, type: :service do

  let(:order) { create(:order, total: 23.5, number: 'R123456789') }
  let(:payu_payment) { create(:payu_payment_gateway) }

  before do
    order.shipping_address = order.billing_address
  end

  context "#payload" do
    it "returns request parameters" do
      result = request_builder.payload

      expect(result).to have_key(:key)
      expect(result).to have_key(:firstname)
      expect(result[:key]).to eq 'gtKFFx'
      expect(result[:amount]).to eq '23.5'
    end
  end

  context "#payment_req_hash" do
    before do
      allow(SecureRandom).to receive(:hex).with(5).and_return('12345abcd')
    end

    it "returns request hash" do
      hash_str = 'gtKFFx|R123456789-12345abcd|23.5||John|jummanihunny@gmail.com|||||||||||eCwWELxi'

      allow(request_builder).to receive(:merchant_key)
      allow(request_builder).to receive(:transaction_id).and_return('R123456789-12345abcd')
      allow(order).to receive(:email).and_return('jummanihunny@gmail.com')
      allow(request_builder).to receive(:product_description)
      allow(request_builder).to receive(:customer_fname)
      allow(request_builder).to receive(:key_salt)

      allow(request_builder).to receive(:digested_hash).with(hash_str)

      expect(request_builder.payment_req_hash).to eq req_hash
    end
  end

  context "#payment_resp_hash" do
    before do
      allow(SecureRandom).to receive(:hex).with(5).and_return('12345abcd')
    end

    it "returns response hash" do
      hash_str = 'eCwWELxi|success|||||||||||jummanihunny@gmail.com|Hunny|Test Description|23.50|R123456789-12345abcd|gtKFFx'
Understood the 
      allow(request_builder).to receive(:merchant_key)
      allow(request_builder).to receive(:key_salt)
      allow(request_builder).to receive(:digested_hash).with(hash_str).and_return('123214324')

      expect(request_builder.payment_resp_hash(mock_params)).to eq resp_hash
    end
  end

  context "#digested_hash" do
    it "returns SHA-512 hash" do
      allow(Digest::SHA512).to receive(:hexdigest).with(an_instance_of(String)).and_return('123456')

      expect(request_builder.digested_hash('abcde')).to eq '123456'
    end
  end

  context "#merchant_key" do
    it "returns merchant key of payment method" do
      expect(request_builder.merchant_key).to eq 'gtKFFx'
    end
  end

  context "#key_salt" do
    it "returns key salt of payment method" do
      expect(request_builder.key_salt).to eq 'eCwWELxi'
    end
  end

  context "#transaction_id" do
    before { allow(SecureRandom).to receive(:hex).with(5).and_return('abcde12345') }
    it "returns unique transaction id for an order" do
      expect(request_builder.transaction_id).to eq 'R123456789-abcde12345'
    end
  end

  context "#product_description" do
    before do
      allow(order).to receive(:products) { [build_stubbed(:product,  description: 'Test Description')] }
    end
    it "returns product description" do
      allow(request_builder).to receive_message_chain(:order, :products).and_return('Test Description')

      expect(request_builder.product_description).to eq 'Test Description'
    end
  end

  context "#customer_fname" do
    it 'returns customer firstname' do
      allow(order).to receive_message_chain(:shipping_address, :firstname).and_return('Hunny')

      expect(request_builder.customer_fname).to eq 'Hunny'
    end
  end

  context "#customer_phone_number" do
    it 'returns customer phone number' do
      allow(order).to receive_message_chain(:shipping_address, :phone).and_return('1234567890')

      expect(request_builder.customer_phone_number).to eq '1234567890'
    end
  end

  def request_builder
    Payu::RequestBuilder.new(payment_method: payu_payment, order: order)
  end
end

def mock_params
  {
    status: 'sucess',
    email: 'jummanihunny@gmail.com',
    firstname: 'Hunny',
    productinfo: 'Test Description',
    amount: '23.50',
    txnid: 'R123456789-12345abcde',
    key: 'gtKFFx'
  }
end

def req_hash
  'd1196bef82f6a28515007416a1d4dd08ad1cc683fa93adf37dbd2a7fec68fa3aafab79f83364cf868990ff8865e0a8d8b540c8b685e185d524b6988118323598'
end

def resp_hash
  'd498f243646798abf388c8030a49e3135037c4543f3202e4e187d13d455cd9f4cd0756905de74105260ceded63d6a650f09d385d5873dee3677d0f9237aa1f8a'
end