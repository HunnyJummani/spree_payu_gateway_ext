class CreateSpreePayuDetails < SpreeExtension::Migration[6.0]
  def change
    create_table :spree_payu_details do |t|
      t.string :mih_pay_id
      t.string :status
      t.string :txnid
      t.string :payment_source
      t.string :pg_type
      t.string :bank_ref_num
      t.string :error
      t.string :error_message
      t.string :issuing_bank
      t.string :card_type
      t.string :card_num
      t.references :spree_payment, null: true
      t.references :spree_order, null: false
    end
  end
end
