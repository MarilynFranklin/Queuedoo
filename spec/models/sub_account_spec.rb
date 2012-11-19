require 'spec_helper'

describe SubAccount do
  describe "associations" do
    it { should belong_to(:user) }
  end
end
