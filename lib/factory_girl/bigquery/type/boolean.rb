module FactoryGirl
  module Bigquery
    module Type
      class Boolean < Base
        cast_type [::FalseClass, ::TrueClass]
      end
    end
  end
end
