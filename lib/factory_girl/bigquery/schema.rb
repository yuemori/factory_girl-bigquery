module FactoryGirl
  module Bigquery
    module Schema
      def self.define(&block)
        DSL.run(block)
      end

      class DSL
        def self.run(block)
          new.instance_eval(&block)
        end

        def table(name)
          table = Table.new(name)
          yield table if block_given?
          FactoryGirl::Bigquery.register_table(table)
        end
      end

      class Table
        module Type
          class MismatchAttributeError < StandardError; end

          class Base
            attr_reader :value

            def initialize(value)
              raise MismatchAttributeError.new, "#{value} mismatch to #{type}" unless valid?(value)
              @value = value
            end

            def type
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

              def data_type(type)
                @type = type
              end
            end
          end

          class Integer < Base
            data_type ::Numeric
          end

          class String < Base
            data_type ::String

            protected

            def cast_value
              string = value.gsub(/"/, '\"')
              %("#{string}")
            end
          end

          class Float < Base
            data_type ::Numeric
          end

          class Record < Base
            data_type ::Hash

            protected

            def cast_value
              raise NotImplementedError.new, 'sorry, this feature is not implemented'
            end
          end

          class Timestamp < Base
            data_type [::Time, ::Date]

            protected

            def cast
              "TIMESTAMP(\"#{value.to_s(:db)}\")"
            end
          end

          class Boolean < Base
            data_type [::FalseClass, ::TrueClass]
          end
        end

        attr_reader :name

        def initialize(name)
          @name = name
        end

        def attributes
          @columns
        end

        def string(column_name, options = {})
          columns << { name: column_name, type: Type::String, options: options }
        end

        def integer(column_name, options = {})
          columns << { name: column_name, type: Type::Integer, options: options }
        end

        def boolean(column_name, options = {})
          columns << { name: column_name, type: Type::Boolean, options: options }
        end

        def float(column_name, options = {})
          columns << { name: column_name, type: Type::Float, options: options }
        end

        def record(column_name, options = {})
          columns << { name: column_name, type: Type::Record, options: options }
        end

        def timestamp(column_name, options = {})
          columns << { name: column_name, type: Type::Timestamp, options: options }
        end

        private

        def columns
          @columns ||= []
        end
      end
    end
  end
end
