module FactoryGirl
  module Bigquery
    module Type
      class Timestamp < Base
        cast_type [::Time, ::Date]

        protected

        def cast_value
          "TIMESTAMP(\"#{value.to_s(:db)}\")"
        end
      end
    end
  end
end
