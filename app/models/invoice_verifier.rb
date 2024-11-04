class InvoiceVerifier
  def self.verify(file)
    images = if file.content_type == "application/pdf"
              convert_pdf_to_images(file)
             else
               [file.tempfile.path]
             end

    # extracted_text = images.map { |image_path| RTesseract.new(image_path).to_s }.join("\n").downcase
    # , "Hospital Name"
    # "Date", "Patient Name",
    # keywords.all? { |keyword| extracted_text.include?(keyword.downcase) }

    extracted_text = images.map { |image_path| RTesseract.new(image_path).to_s }.join("\n").downcase
    keywords = ["Invoice", "Allinahealth", "total charges", "Payment", "balance"]
    #, "statement", "terms", "amount", "invoice number", "date of issue", "biledto", "billed by", "description", "quantity"

    matching_keywords = keywords.count { |keyword| extracted_text.include?(keyword.downcase) }
    # byebug
    threshold = 0.55
    minimum_matches = (threshold * keywords.size).ceil

    matching_keywords >= minimum_matches
  end

  def self.convert_pdf_to_images(file)
    pdf = MiniMagick::Image.read(file.tempfile)
    pdf.pages.each_with_index.map do |page, index|
      image_path = "#{file.tempfile.path}-page#{index}.png"
      page.format("png", 0) { |image| image.write(image_path) }
      image_path
    end
  end
end
