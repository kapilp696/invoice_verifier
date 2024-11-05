module InvoiceVerifier
  extend ActiveSupport::Concern

  HOSPITAL_KEYWORDS_WITH_WEIGHTS = {
    "Invoice" => 2, "total charges" => 1, "Payment" => 1, "balance" => 1, "Emergency" => 2,"Admission" => 3,
    "clinic" => 1, "medicine" => 1, "surgery" => 2, "medical" => 2, "Patient" => 3, "Surgical" => 2, "Pharmacy" => 1,
    "Health" => 2, "hospital" => 3, "Treatment" => 2, "doctors" => 1, "disease" => 1, "pharma" => 1, "diagnosis" => 2,
    "health insurance" => 1, "Intensive Care Unit" => 2, "billed by" => 1, "billed to" => 1, "Consultation" => 2,
    "Lab Tests" => 2, "quantity" => 1, "description" => 1, "statement" => 1, "infection" => 1, "Nursing" => 2,
    "Prescription" => 1, "invoice number" => 1, "name" => 1, "physician" => 2, "Discharge" => 2,
    "Vitals Monitoring" => 1, "CT Scan" => 2, "MRI" => 2, "Health Assessment" => 1
  }

  HOSPITAL_KEYWORD_MATCH_THRESHOLD = 0.14

  def self.verify?(file)
    extracted_text = extract_text_from_file(file)

    total_keyword_score = 0
    maximum_possible_score = HOSPITAL_KEYWORDS_WITH_WEIGHTS.values.sum

    HOSPITAL_KEYWORDS_WITH_WEIGHTS.each do |keyword, weight|
      if extracted_text.include?(keyword.downcase)
        total_keyword_score += weight
      end
    end
    match_score_percentage = total_keyword_score.to_f / maximum_possible_score
    match_score_percentage >= HOSPITAL_KEYWORD_MATCH_THRESHOLD
  end

  private

  def self.convert_pdf_to_images(file)
    pdf = MiniMagick::Image.read(file.tempfile)
    pdf.pages.each_with_index.map do |page, index|
      image_path = "#{file.tempfile.path}-page#{index}.png"
      page.format("png") { |image| image.write(image_path) }
      image_path
    end
  end

  def self.extract_text_from_file(file)
    if file.content_type == "application/pdf"
      images = convert_pdf_to_images(file)
      extracted_text = images.map { |image_path| RTesseract.new(image_path).to_s }.join("\n").downcase
    else
      extracted_text = RTesseract.new(file.tempfile.path).to_s.downcase
    end
    extracted_text
  end
end
