class Api::V1::InvoiceItems::InvoiceItemsFinderController < ApplicationController
  def show
    render json: InvoiceItem.find_by(invoice_item_params)
  end

  private

  def invoice_item_params
    params.permit(:quantity, :unit_price, :created_at, :updated_at)
  end

end
