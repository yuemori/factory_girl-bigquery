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
                self.name.split('::').last.to_s.upcase
              end
            end
          end

          class Integer < Base
            cast_type ::Numeric
          end

          class String < Base
            cast_type ::String

            protected

            def cast_value
              string = value.gsub(/"/, '\"')
              %("#{string}")
            end
          end

          class Float < Base
            cast_type ::Numeric
          end

          class Record < Base
            cast_type ::Hash

            protected

            def cast_value
              raise NotImplementedError.new, 'sorry, this feature is not implemented'
            end
          end

          class Timestamp < Base
            cast_type [::Time, ::Date]

            protected

            def cast_value
              "TIMESTAMP(\"#{value.to_s(:db)}\")"
            end
          end

          class Boolean < Base
            cast_type [::FalseClass, ::TrueClass]
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

        def to_schema
          @columns.each_with_object([]) { |column, arr| arr << { name: column[:name], type: column[:type].to_s } }
        end

        private

        def columns
          @columns ||= []
        end
      end
    end
  end
end
