require 'rails_helper'

RSpec.describe RoutesController, type: :controller do
  it "routes must have valid string syntax in order to be created" do
    post :create, body: {
      route: "bad string",
      price: 55
    }.to_json

    expect(response).to have_http_status(400)
  end

  it "price must be an integer in order to create a route" do
    post :create, body: {
      route: "ORL-GDC",
      price: "string"
    }.to_json

    expect(response).to have_http_status(400)
  end

  it "price cannot be negative in order to create a route" do
    post :create, body: {
      route: "ORL-GDC",
      price: -10
    }.to_json

    expect(response).to have_http_status(400)
  end

  it "a new route can be created" do
    post :create, body: {
      route: "ORL-GRU",
      price: 40
    }.to_json

    expect(response).to have_http_status(201)
  end

  it "the cheapest route can be fetched" do
    get :cheapest, params: {
      route: "GRU-SCL"
    }

    expect(response).to have_http_status(200)
  end
end
