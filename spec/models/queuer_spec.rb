require 'spec_helper'

describe Queuer do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "associations" do
    it { should belong_to :line }
  end
end
