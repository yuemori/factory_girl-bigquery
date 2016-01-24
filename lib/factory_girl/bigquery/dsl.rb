module FactoryGirl
  module Bigquery
    class DSL
      def factory(name, options = {}, &block)
        factory = Factory.new(name, options)
        factory.instance_eval(&block) if block_given?
        FactoryGirl::Bigquery.register_factory(factory)
      end

      def self.run(block)
        new.instance_eval(&block)
      end
    end
  end
end
