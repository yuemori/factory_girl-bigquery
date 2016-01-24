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
          class Integer
          end

          class String
          end

          class Float
          end

          class Record
          end

          class Timestamp
          end

          class Boolean
          end
        end

        attr_reader :name

        def initialize(name)
          @name = name
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
