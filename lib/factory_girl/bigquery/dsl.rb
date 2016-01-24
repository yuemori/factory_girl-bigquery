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

      class Factory
        attr_reader :name

        def initialize(name, options)
          define_attribute_for(FactoryGirl::Bigquery.table_definition(name))

          @name = name
          @options = options
        end

        def define_attribute_for(table_attributes)
          table_attributes.each do |attribute|
            self.class.send(:define_method, attribute[:name]) do |value|
              attribute[:type].validate!(value)
              attributes[:name] = value
            end
          end
        end

        def attributes
          @attributes ||= {}
        end
      end
    end
  end
end
