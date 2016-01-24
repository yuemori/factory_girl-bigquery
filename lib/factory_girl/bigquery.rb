require "factory_girl/bigquery/configuration"
require "factory_girl/bigquery/schema"
require "factory_girl/bigquery/version"

module FactoryGirl
  module Bigquery
    class << self
      def configure
        @configuration = Configuration.new
        yield configuration if block_given?
        configuration
      end

      def configuration
        @configuration || configure
      end

      def register_table(table)
        tables[table.name] = table
      end

      private

      def tables
        @tables ||= {}
      end
    end
  end
end
