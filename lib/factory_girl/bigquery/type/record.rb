module FactoryGirl
  module Bigquery
    module Type
      class Record < Base
        cast_type ::Hash

        protected

        def cast_value
          raise NotImplementedError.new, 'sorry, this feature is not implemented'
        end
      end
    end
  end
end
