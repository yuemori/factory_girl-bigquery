module FactoryGirl
  module Bigquery
    module Type
      class String < Base
        cast_type ::String

        protected

        def cast_value
          string = value.gsub(/"/, '\"')
          %("#{string}")
        end
      end
    end
  end
end
