require 'spec_helper'

describe FactoryGirl::Bigquery do
  before do
    FactoryGirl::Bigquery.configure do |config|
      config.dataset = 'test'
    end
  end

  describe 'test' do
    it { expect(1).to eq 1 }
  end
end
