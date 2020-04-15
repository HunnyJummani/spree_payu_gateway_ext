require 'spec_helper'

describe Payu::CreatePayuDetails, type: :service do
  context "#create" do
    let(:order) { create(:order, number: 'R285572207') }
    let(:create_payu_details) { Payu::CreatePayuDetails.new(order, params) }
    before do
      allow(order).to receive(:payments).and_return([create(:payu_payment)])
    end

    it "creates payu_details" do
      result = Payu::CreatePayuDetails.new(order, params).create

      expect(result).to be_instance_of(Spree::PayuDetail)
      expect(order.payu_details).to exist
      expect(result.txnid).to eq 'R285572207-5a22751633'
      expect(result.mih_pay_id).to eq '403993715520850376'
    end
  end
end

def params
  {
    "mihpayid"=>"403993715520850376",
    "mode"=>"CC",
    "status"=>"success",
    "unmappedstatus"=>"captured",
    "key"=>"gtKFFx",
    "txnid"=>"R285572207-5a22751633",
    "amount"=>"87.99",
    "cardCategory"=>"domestic",
    "discount"=>"0.00",
    "net_amount_debit"=>"87.99",
    "addedon"=>"2020-04-15 10:36:46",
    "productinfo"=>"Occaecati est laudantium aut ipsam enim. Laborum eaque magnam soluta ullam quia non accusantium quis",
    "firstname"=>"Hunny",
    "lastname"=>"",
    "address1"=>"",
    "address2"=>"",
    "city"=>"",
    "state"=>"",
    "country"=>"",
    "zipcode"=>"",
    "email"=>"admin@gmail.com",
    "phone"=>"9426288363",
    "udf1"=>"", "udf2"=>"", "udf3"=>"", "udf4"=>"", "udf5"=>"", "udf6"=>"", "udf7"=>"", "udf8"=>"", "udf9"=>"", "udf10"=>"",
    "hash"=>"91c6fe89025f03397518d6cd71a778069bafe851bc78c8482c5a03c8611c90a1224dcd744bd6bf73f6a2ff5e29e255b0cd9b1041b3912bb93c7086016f76d00d",
    "field1"=>"010610001415", "field2"=>"000000", "field3"=>"202010686389935", "field4"=>"700202010613607526", "field5"=>"01", "field6"=>"00",
    "field7"=>"AUTHPOSITIVE", "field8"=>"Approved or completed successfully", "field9"=>"No Error",
    "payment_source"=>"payu",
    "PG_TYPE"=>"HDFCPG",
    "bank_ref_num"=>"202010686389935",
    "bankcode"=>"CC",
    "error"=>"E000", "error_Message"=>"No Error",
    "name_on_card"=>"Test",
    "cardnum"=>"512345XXXXXX2346",
    "cardhash"=>"This field is no longer supported in postback params.",
    "issuing_bank"=>"HDFC",
    "card_type"=>"MAST",
    "controller"=>"spree/payu_handler",
    "action"=>"success"
  }.with_indifferent_access
end