require "spec_helper"

describe Comsat::Client do
  subject { described_class.new }
  let(:undefined_svc) { "svc://api_key:X@host/scope" }
  let(:defined_svc)   { "campfire://api_key:X@blossom.campfirenow.com/scope" }
  let(:failure_svc)   { "failure://X:X@failure.com/scope" }

  describe "#routes" do
    it "has zero routes configured by default" do
      subject.routes.should be_empty
    end
  end

  describe "#create_route" do

    describe "specify event_types" do
      before do
        subject.create_route("test_route", "notice", [undefined_svc, defined_svc])
      end

      it "should register a route with base class" do
        subject.routes.should_not be_empty
      end

      it "should create a route" do
        subject.routes.first.name.should == "test_route"
      end

      it "should have one service initiated on the event_type 'notice'" do
        subject.routes.first.services["notice"].compact.length.should == 1
      end

      it "should have a campfire service initiated" do
        subject.routes.first.services["notice"].compact.first.class.should == Comsat::Campfire
      end

      it "should provide an event type" do
        subject.routes.first.event_type == "notice"
      end
    end

    describe "no event_type specified" do
      before do
        subject.create_route("test_route2", [defined_svc])
      end

      it "should register a route with base class" do
        subject.routes.should_not be_empty
      end

      it "should create a route" do
        subject.routes.first.name.should == "test_route2"
      end

      it "should have one service initiated on all event_types" do
        subject.routes.first.services["notice"].compact.length.should == 1
        subject.routes.first.services["alert"].compact.length.should == 1
        subject.routes.first.services["resolve"].compact.length.should == 1
      end
    end
  end

  describe "#notify" do
    it "should notify the valid services" do
      subject.create_route("test_route", "notice", [undefined_svc, defined_svc])
      subject.notify("test_route", {
        :message => "message",
        :source => "test"
      })
      Comsat.notifications.size.should == 1
    end

    it "should return false if any notifications failed" do
      subject.create_route("failure_route", "notice", [failure_svc])
      subject.notify("failure_route", {
        :message => "message",
        :source => "test"
      }).should be_false
    end
  end
end
