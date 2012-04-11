require "spec_helper"

describe Comsat::Client do
  subject { described_class.new }
  let(:undefined_svc) { "svc://api_key:X@host/scope" }
  let(:defined_svc) { "campfire://api_key:X@blossom.campfirenow.com/scope" }

  describe "#routes" do
    it "has zero routes configured" do
      subject.routes.should be_empty
    end
  end

  describe "#create_route" do
    before do
      subject.create_route("test_route", "notice", [undefined_svc, defined_svc])
    end

    it "should register a route" do
      subject.routes.should_not be_empty
    end

    it "should create a route" do
      subject.routes.first.name.should == "test_route"
    end

    it "should have one service defined" do
      subject.routes.first.services.length.should == 1
    end
  end
end
