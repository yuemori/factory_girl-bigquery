module FactoryGirl
  module Bigquery
    module Type
      class Float < Base
        cast_type ::Numeric
      end
    end
  end
end
