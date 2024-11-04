class InvoicesController < ApplicationController
  def verify
    if request.post?
      @file = params[:file]
      @is_genuine = InvoiceVerifier.verify(@file)

      if @is_genuine
        flash[:notice] = "The invoice appears to be genuine."
      else
        flash[:alert] = "Warning: The invoice may be fake."
      end
      redirect_to verify_invoice_path
    end
  end
end
