require 'rails_helper'

RSpec.describe 'Invoices API' do
  it 'returns a list of invoices' do
    create_list(:invoice, 3)

    get '/api/v1/invoices.json'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output.count).to eq(3)
  end

  it 'returns an individual invoice' do
    invoice = create(:invoice, status: 'shipped')

    get "/api/v1/invoices/#{invoice.id}.json"
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["status"]).to eq('shipped')
  end

  it 'finds an invoice by id' do
    invoice = create(:invoice, status: 'shipped')

    get "/api/v1/invoices/find.json?id=#{invoice.id}"
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["status"]).to eq('shipped')
  end

  it 'finds an invoice by status' do
    create(:invoice, id: 2, status: 'shipped')

    get '/api/v1/invoices/find.json?status=shipped'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["id"]).to eq(2)
  end

  it 'finds an invoice by the time it was created' do
    create(:invoice, status: 'shipped', created_at: '1999-01-01')

    get '/api/v1/invoices/find.json?created_at=1999-01-01'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["status"]).to eq('shipped')
  end

  it 'finds an invoice by the time it was updated' do
    create(:invoice, status: 'shipped', updated_at: '1999-01-01')

    get '/api/v1/invoices/find.json?updated_at=1999-01-01'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["status"]).to eq('shipped')
  end

  it 'finds multiple invoices by status' do
    create_list(:invoice, 2, status: 'shipped')

    get '/api/v1/invoices/find_all.json?status=shipped'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output.count).to eq(2)
  end

  it 'finds a random invoice' do
    create(:invoice, status: 'shipped')

    get '/api/v1/invoices/random.json'
    output = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(output["status"]).to eq('shipped')
  end

  it 'returns correct scope of json' do
    invoice = create(:invoice)
    get "/api/v1/invoices/#{invoice.id}.json"
    actual = JSON.parse(response.body)
    expected = {
      'id' => invoice.id,
      'status' => invoice.status,
      'customer_id' => invoice.customer_id,
      'merchant_id' => invoice.merchant_id
    }

    expect(actual).to eq(expected)
  end

  it 'returns a collection of associated transactions' do
    invoice = create(:invoice)
    transaction = create(:transactions, invoice_id: invoice.id, result: 'failed')
    create(:transactions, invoice_id: invoice.id)
    get "/api/v1/invoices/#{invoice.id}/transactions"
    expected = JSON.parse(response.body)

    expect(expected.count).to eq(2)
    expect(expected[0]['result']).to eg('failed')
  end

  it 'returns a collection of associated invoice items' do
    # GET /api/v1/invoices/:id/invoice_items returns a collection of associated invoice items
  end

  it 'returns a collection of associated items' do
    # GET /api/v1/invoices/:id/items returns a collection of associated items
  end

  it 'returns the associated customer' do
    # GET /api/v1/invoices/:id/customer returns the associated customer
  end

  it 'returns the associated merchant' do
    # GET /api/v1/invoices/:id/merchant returns the associated merchant
  end
end
