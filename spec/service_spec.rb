require "spec_helper"

describe Comsat::Service::Base do
  let(:unsupported)     { "svc://api_key:X@host/scope" }
  subject { described_class.new(unsupported) }

  it "should provide credentials in an object" do
    subject.credentials.class.should == OpenStruct
  end
end
