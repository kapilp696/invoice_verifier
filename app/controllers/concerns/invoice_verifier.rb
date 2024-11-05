require "google/cloud/document_ai/v1"

module InvoiceVerifier
  extend ActiveSupport::Concern

  def self.verify?(file)
    analyze_with_document_ai(file)
  end

  private

  def self.analyze_with_document_ai(file)
    client = ::Google::Cloud::DocumentAI::V1::DocumentProcessorService::Client.new do |config|
      config.endpoint = "us-documentai.googleapis.com"
    end

    name = client.processor_path(
      project: "hospital-invoice-verifier",
      location: "us",
      processor: "72eff6da83d4723d"
    )

    content = File.binread file.tempfile.path

    request = Google::Cloud::DocumentAI::V1::ProcessRequest.new(
      skip_human_review: true,
      name: name,
      raw_document: {
        content: content,
        mime_type: file.content_type
      }
    )

    result = client.process_document(request)
    document_type = result.document.entities.map(&:type)

    document_type.any? { |type| type.downcase.include?("hospital") }
  end
end
