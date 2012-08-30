describe Viaduct::Environment do
  let(:instance) { described_class.new }

  it "should be a hash" do
    instance.should be_empty
    instance["foo"] = "bar"
    instance["foo"].should == "bar"
  end

  it "should not support indifferent access" do
    instance["foo"] = "bar"
    instance[:foo].should == nil
  end
end
