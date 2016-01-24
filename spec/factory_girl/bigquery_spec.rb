require 'spec_helper'

describe FactoryGirl::Bigquery do
  before do
    FactoryGirl::Bigquery.configure do |config|
      config.dataset = 'test'
    end

    FactoryGirl::Bigquery::Schema.define do
      table :user do |t|
        t.string  'first_name'
        t.string  'last_name'
        t.boolean 'admin'
        t.integer 'age'
        t.float   'height'
      end
    end

    FactoryGirl::Bigquery.define do
      factory :user do
        first_name "John"
        last_name  "Doe"
        admin      false
        age        26
        height     167.2
      end
    end
  end

  describe '#to_sql' do
    subject { FactoryGirl::Bigquery.to_sql(:user) }
    let(:expect_sql) { 'SELECT * FROM (SELECT "John" AS first_name, "Doe" AS last_name, false AS admin, 26 AS age, 167.2 AS height)' }
    it { is_expected.to eq expect_sql }
  end
end
