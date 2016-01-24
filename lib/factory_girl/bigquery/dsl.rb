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

        def to_sql
          select_clause = attributes.values.map(&:to_sql).join(',')
          "SELECT * FROM (SELECT #{select_clause})"
        end

        def define_attribute_for(table_attributes)
          table_attributes.each do |attribute|
            self.class.send(:define_method, attribute[:name]) do |value|
              attributes[attribute[:name]] = Attribute.new(attribute[:name], attribute[:type].new(value))
            end
          end
        end

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

        def attributes
          @attributes ||= {}
        end
      end
    end
  end
end
