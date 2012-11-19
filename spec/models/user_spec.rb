require 'spec_helper'

describe User do
  describe "associations" do
    it { should have_many(:lines) }
    it { should have_one(:sub_account) }
  end
end
