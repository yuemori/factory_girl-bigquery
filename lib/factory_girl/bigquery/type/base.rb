module FactoryGirl
  module Bigquery
    module Type
      class Base
        class MismatchAttributeError < StandardError; end

        attr_reader :value

        def initialize(value)
          raise MismatchAttributeError.new, "#{value} mismatch to #{data_type}" unless valid?(value)
          @value = value
        end

        def data_type
          self.class.type
        end

        def valid?(value)
          self.class.valid?(value)
        end

        def cast
          "CAST(NULL AS #{self.class.name.split('::').last})" if value.nil?
          cast_value
        end

        protected

        def cast_value
          value.to_s
        end

        class << self
          attr_reader :type

          def valid?(value)
            if @type.is_a? Array
              @type.any? { |c| value.is_a? c }
            else
              value.is_a? @type
            end
          end

          def cast_type(type)
            @type = type
          end

          def to_s
            name.split('::').last.to_s.upcase
          end
        end
      end
    end
  end
end
