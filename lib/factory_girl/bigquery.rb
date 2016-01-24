require "factory_girl/bigquery/configuration"
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
    end
  end
end
