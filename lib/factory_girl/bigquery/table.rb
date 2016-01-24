module FactoryGirl
  module Bigquery
    class Table
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
