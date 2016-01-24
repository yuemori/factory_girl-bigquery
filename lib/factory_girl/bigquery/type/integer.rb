module FactoryGirl
  module Bigquery
    module Type
      class Integer < Base
        cast_type ::Numeric
      end
    end
  end
end
