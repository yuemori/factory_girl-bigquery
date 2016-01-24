module FactoryGirl
  module Bigquery
    class Attribute
      attr_reader :name, :type

      def initialize(name, type)
        @name = name
        @type = type
      end

      def to_sql
        "#{type.cast} AS #{name}"
      end
    end
  end
end
