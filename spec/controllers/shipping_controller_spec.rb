require 'rails_helper'

RSpec.describe ShippingController, type: :controller do
  let(:complete_query) {
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
      # ounces: "160",
      # width: "12",
      # height: "24",
      # length: "12"
    }
      # ounces & inches
      # EVENTUALLY: options?
  }

  {"ups" => 7, "usps" => 6}.each do |shipper, count|
    describe "GET 'show' id: #{shipper}" do
      before :each do
        query = complete_query
        query[:id] = shipper
        get :show, query
      end

      it "is successful" do
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        # ex. [["UPS Standard", 2345], ["UPS Global", 3456]]
        it "lists multiple shipment types" do
          expect(@response.count).to eq count
        end

        it "lists shipment type and estimated cost" do
          @response.each do |estimate|
            expect(estimate.count).to eq 2
          end
        end
      end
    end
  end
end
