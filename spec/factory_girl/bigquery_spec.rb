require 'spec_helper'

describe FactoryGirl::Bigquery do
  before do
    FactoryGirl::Bigquery.configure do |config|
      config.dataset = 'test'
    end

    FactoryGirl::Bigquery::Schema.define do
      table :user do |t|
        t.string  'first_name', null: false
        t.string  'last_name',  null: false
        t.boolean 'admin',      null: false
      end
    end
  end

  describe 'test' do
    it { expect(1).to eq 1 }
  end
end
