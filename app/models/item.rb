class Item < ApplicationRecord
  default_scope { order(id: :asc) }

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  def unit_price_in_dollars
    '%.2f' % (self.unit_price / 100.0)
  end

  def best_day
    self.invoices.joins('INNER JOIN transactions
                               ON transactions.invoice_id = invoices.id')
                        .where('transactions.result = ?', 'success')
                        .select('invoices.created_at, SUM(invoice_items.quantity) AS items_sold')
                        .group('invoices.id')
                        .order('items_sold DESC, invoices.created_at DESC')
                        .limit(1)
                        .first
                        .created_at
  end

  def self.most_items(quantity)
    Item.unscoped.joins(:invoice_items)
                  .joins('INNER JOIN transactions
                          ON transactions.invoice_id = invoice_items.invoice_id')
                  .where('transactions.result = ?', 'success')
                  .select('items.*, sum(invoice_items.quantity) AS items_sold')
                  .group('items.id')
                  .order('items_sold DESC')
                  .limit(quantity)
  end

  def self.most_revenue(quantity)
    Item.unscoped.joins(:invoice_items)
        .joins('INNER JOIN transactions
                ON transactions.invoice_id = invoice_items.invoice_id')
        .where('transactions.result = ?', 'success')
        .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS subtotal')
        .group('items.id')
        .order('subtotal DESC')
        .limit(quantity)
  end
end
