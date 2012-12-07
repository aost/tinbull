require 'spec_helper'

describe Section do
  before do
    @section = FactoryGirl.build(:section)
  end

  subject { @section }

  it { should be_valid }

  it { should respond_to(:name) }
  
end
