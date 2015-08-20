require 'rails_helper'

RSpec.describe ShippingController, type: :controller do
  let(:valid_query) {
    { origin_country: "US",
      origin_zip: "98101",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_address1: "301 Union St",
      origin_address2: "PO BOX 55555-5555",
      destination_country: "US",
      destination_zip: "98195",
      destination_state: "WA",
      destination_city: "Seattle",
      destination_address1: "University of Washington",
      destination_address2: "",
    }
  }
 # Invalid destination_zip: "98"
  let(:invalid_query) {
    { origin_country: "US",
      origin_zip: "98101",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_address1: "301 Union St",
      origin_address2: "PO BOX 55555-5555",
      destination_country: "US",
      destination_zip: "98",
      destination_state: "WA",
      destination_city: "Seattle",
      destination_address1: "University of Washington",
      destination_address2: "",
    }
  }

  {"ups" => 7, "usps" => 6}.each do |shipper, count|
    describe "GET 'show' id: #{shipper}" do
      before :each do
        VCR.use_cassette("valid_shipping", record: :new_episodes) do
          query = valid_query
          query[:id] = shipper
          get :show, query
        end
      end

      it "is successful" do
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do

        # ex. [["UPS Standard", 2345], ["UPS Global", 3456]]
        it "lists multiple shipment types" do
          @response = JSON.parse response.body
          expect(@response["data"].count).to eq count
        end

        it "lists shipment type and estimated cost" do
          @response = JSON.parse response.body
          @response["data"].each do |estimate|
            expect(estimate.count).to eq 3
          end
        end
      end
    end
  end

  describe "fedex is invalid carrier" do
    before :each do
      query = valid_query
      query[:id] = "fedex"
      get :show, query
    end

    it "is has 400 code status" do
      expect(response.response_code).to eq 400
    end

    it "displays error message 'Ivalid carrier' for fedex" do
      @response = JSON.parse response.body
      expect(@response["message"]).to eq "Invalid carrier"
    end
  end

  describe '98 is invalid zip code' do
    before :each do
      VCR.use_cassette("invalid_shipping", record: :new_episodes) do
        query = invalid_query
        query[:id] = "ups"
        get :show, query
      end
    end

    it "throws an error message 'Ivalid address' for zip code 98" do
      @response = JSON.parse response.body
      expect(@response["message"]).to eq "Invalid address"
    end

    it "is has 400 code status" do
      expect(response.response_code).to eq 400
    end
  end
end
