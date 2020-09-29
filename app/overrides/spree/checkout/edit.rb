Deface::Override.new(:virtual_path => 'spree/checkout/edit',
                     :name => 'Add id to Save and Continue Button',
                     :set_attributes => 'code[erb-loud]:contains("submit_tag")',
                     :attributes => {:id => 'save-cont-bolt-checkout'},
                     :disabled => false)