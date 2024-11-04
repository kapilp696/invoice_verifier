Rails.application.routes.draw do
  root "invoices#verify"
  post "verify_invoice", to: "invoices#verify", as: "verify_invoice"
end
