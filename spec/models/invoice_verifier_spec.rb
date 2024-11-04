require 'rails_helper'

RSpec.describe InvoiceVerifier, type: :model do
  let(:valid_pdf) { fixture_file_upload('/sample_invoice.pdf', 'application/pdf') }
  let(:valid_image) { fixture_file_upload('/sample_invoice.png', 'image/png') }
  let(:invalid_image) { fixture_file_upload('/fake_invoice.png', 'image/png') }

  describe '.verify' do
    it 'returns true for a genuine PDF invoice' do
      expect(InvoiceVerifier.verify(valid_pdf)).to be true
    end

    it 'returns true for a genuine image invoice' do
      expect(InvoiceVerifier.verify(valid_image)).to be true
    end

    it 'returns false for a fake image invoice' do
      expect(InvoiceVerifier.verify(invalid_image)).to be false
    end
  end
end
