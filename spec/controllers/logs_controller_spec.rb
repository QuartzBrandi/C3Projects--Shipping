require 'rails_helper'

RSpec.describe LogsController, type: :controller do

  describe "Create method" do
    let(:params) {
      {
      :id => "tux",
      :order_number => "21",
      :provider => "UPS Ground",
      :cost => "1125",
      :estimate => "",
      :purchase_time => "2015-08-20 20:45:59 UTC"
      }
    }
    before :each do
      post :create, params
    end

    it "is successful after creating log" do
      expect(response.response_code).to eq 201
    end

    it "returns json" do
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "creates a record in Logs table" do
      expect(Log.count).to eq 1
    end

    it "has 'UPS Ground' provider" do
      expect(Log.first.provider).to eq "UPS Ground"
    end
  end
end
