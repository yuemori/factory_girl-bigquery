require "factory_girl/bigquery/configuration"
require "factory_girl/bigquery/schema"
require "factory_girl/bigquery/dsl"
require "factory_girl/bigquery/version"

module FactoryGirl
  module Bigquery
    class << self
      class UndefinedTableError < StandardError; end

      def configure
        @configuration = Configuration.new
        yield configuration if block_given?
        configuration
      end

      def configuration
        @configuration || configure
      end

      def define(&block)
        DSL.run(block)
      end

      def register_table(table)
        tables[table.name] = table
      end

      def table_definition(name)
        raise UndefinedTableError.new, "#{name} table is undefined" unless tables.key? name
        tables[name].attributes
      end

      def register_factory(factory)
        factories[factory.name] = factory
      end

      private

      def tables
        @tables ||= {}
      end

      def factories
        @factories ||= {}
      end
    end
  end
end
