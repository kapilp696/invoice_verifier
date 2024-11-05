class InvoicesController < ApplicationController
  include InvoiceVerifier

  def verify
    if request.post?
      @file = params[:file]
      @is_genuine = InvoiceVerifier.verify?(@file)

      if @is_genuine
        flash[:notice] = "Uploaded invoice is a hospital invoice."
      else
        flash[:alert] = "Uploaded invoice is not a hospital invoice."
      end
      redirect_to root_path
    end
  end
end
