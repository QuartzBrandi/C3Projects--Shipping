require 'rails_helper'

RSpec.describe Log, type: :model do

# Validations--------------------------------------------------------
  describe "validations" do
    before :each do
      @log = create :log
    end

    it "is valid" do
      expect(@log).to be_valid
    end

    it "requires an order_number" do
      @log.order_number = nil
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:order_number)
    end

    it "requires a provider" do
      @log.provider = nil
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:provider)
    end

    it "requires a cost" do
      @log.cost = nil
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:cost)
    end

    it "requires a purchase_time" do
      @log.purchase_time = nil
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:purchase_time)
    end

    it "doesn't eccept 'some word' for price" do
      @log.cost = "some word"
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:cost)
    end

    it "doesn't eccept 'some word' for order_number" do
      @log.order_number = "some word"
      expect(@log).to be_invalid
      expect(@log.errors.keys).to include(:order_number)
    end

    # it "requires date format for purchase_time" do
    #   @log.purchase_time = 2015
    #   expect(@log).to be_invalid
    #   expect(@log.errors.keys).to include(:purchase_time)
    # end
  end
end
