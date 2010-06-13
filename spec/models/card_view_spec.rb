require 'spec_helper'

describe CardView do
  
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    CardView.create!(@valid_attributes)
  end
  
end
