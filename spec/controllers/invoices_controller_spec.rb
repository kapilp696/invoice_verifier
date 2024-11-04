require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe 'POST #verify' do
    let(:genuine_invoice_pdf) { fixture_file_upload('/sample_invoice.pdf', 'application/pdf') }
    let(:fake_invoice_pdf) { fixture_file_upload('/fake_invoice.pdf', 'application/pdf') }
    let(:genuine_invoice_image) { fixture_file_upload('/sample_invoice.png', 'image/png') }
    let(:fake_invoice_image) { fixture_file_upload('/fake_invoice.png', 'image/png') }

    it 'redirects to the verify page' do
      post :verify, params: { file: genuine_invoice_pdf }
      expect(response).to redirect_to(verify_invoice_path)
    end

    it 'sets a flash notice if the invoice is genuine' do
      post :verify, params: { file: genuine_invoice_pdf }
      expect(flash[:notice]).to eq("The invoice appears to be genuine.")
    end

    it 'sets a flash alert if the invoice is fake' do
      post :verify, params: { file: fake_invoice_pdf }
      expect(flash[:alert]).to eq("Warning: The invoice may be fake.")
    end

    it 'sets a flash notice if the image invoice is genuine' do
      post :verify, params: { file: genuine_invoice_image }
      expect(flash[:notice]).to eq("The invoice appears to be genuine.")
    end

    it 'sets a flash alert if the image invoice is fake' do
      post :verify, params: { file: fake_invoice_image }
      expect(flash[:alert]).to eq("Warning: The invoice may be fake.")
    end
  end
end
