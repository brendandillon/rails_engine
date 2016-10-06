class Api::V1::Invoices::InvoiceItemsController < ApplicationController
  def index
    @invoice_items = Invoice.find_by(id: params[:invoice_id]).invoice_items
  end
end
