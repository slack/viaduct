describe Middleware::Environment do
  let(:instance) { described_class.new }

  it "should be a hash" do
    instance.should be_empty
    instance["foo"] = "bar"
    instance["foo"].should == "bar"
  end

  it "should be a hash accessible by string or symbol" do
    instance["foo"] = "bar"
    instance[:foo].should == "bar"
  end
end
