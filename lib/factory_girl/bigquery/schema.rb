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
            def self.valid?(value)
              if @definition_class.is_a? Array
                @definition_class.any? { |c| value.is_a? c }
              else
                value.is_a? @definition_class
              end
            end

            def self.validate!(value)
              raise MismatchAttributeError.new, "#{value} mismatch to #{@definition_class}" unless valid?(value)
            end
          end

          class Integer < Base
            @definition_class = ::Numeric
          end

          class String < Base
            @definition_class = ::String
          end

          class Float < Base
            @definition_class = ::Numeric
          end

          class Record < Base
            @definition_class = ::Hash
          end

          class Timestamp < Base
            @definition_class = [::Time, ::Date]
          end

          class Boolean < Base
            @definition_class = [::FalseClass, ::TrueClass]
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
